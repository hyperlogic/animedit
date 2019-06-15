//
//  TreeModel
//
//  Created by Anthony Thibault on 6/5/2019
//  Copyright 2019 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html
//

#include "treeitem.h"

#include <QDebug>
#include <QFile>
#include <QtGlobal>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStringList>

#include "treemodel.h"

TreeModel::TreeModel(QObject* parent) : QAbstractItemModel(parent) {
    _roleNameMapping[TreeModelRoleName] = "name";
    _roleNameMapping[TreeModelRoleType] = "type";
    _roleNameMapping[TreeModelRoleData] = "data";

    QList<QVariant> rootData;
    rootData << "root" << "root" << "root";
    _rootItem = new TreeItem(rootData);
}

TreeModel::~TreeModel() {
    delete _rootItem;
}

int TreeModel::columnCount(const QModelIndex& parent) const {
    if (parent.isValid()) {
        return static_cast<TreeItem*>(parent.internalPointer())->columnCount();
    } else {
        return _rootItem->columnCount();
    }
}

QVariant TreeModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid()) {
        return QVariant();
    }

    if (role != TreeModelRoleName && role != TreeModelRoleType && role != TreeModelRoleData) {
        return QVariant();
    }

    TreeItem* item = static_cast<TreeItem*>(index.internalPointer());

    return item->data(role - Qt::UserRole - 1);
}

Qt::ItemFlags TreeModel::flags(const QModelIndex& index) const {
    if (!index.isValid()) {
        return Qt::NoItemFlags;
    }

    return QAbstractItemModel::flags(index);
}

QVariant TreeModel::headerData(int section, Qt::Orientation orientation, int role) const {
    if (orientation == Qt::Horizontal && role == Qt::DisplayRole) {
        return _rootItem->data(section);
    }

    return QVariant();
}

QModelIndex TreeModel::index(int row, int column, const QModelIndex& parent) const {
    if (!hasIndex(row, column, parent)) {
        return QModelIndex();
    }

    TreeItem *parentItem;

    if (!parent.isValid()) {
        parentItem = _rootItem;
    } else {
        parentItem = static_cast<TreeItem*>(parent.internalPointer());
    }

    TreeItem *childItem = parentItem->child(row);
    if (childItem) {
        return createIndex(row, column, childItem);
    } else {
        return QModelIndex();
    }
}

QModelIndex TreeModel::parent(const QModelIndex& index) const {
    if (!index.isValid()) {
        return QModelIndex();
    }

    TreeItem *childItem = static_cast<TreeItem*>(index.internalPointer());
    TreeItem *parentItem = childItem->parentItem();

    if (parentItem == _rootItem) {
        return QModelIndex();
    }

    return createIndex(parentItem->row(), 0, parentItem);
}

int TreeModel::rowCount(const QModelIndex& parent) const {
    TreeItem *parentItem;
    if (parent.column() > 0) {
        return 0;
    }

    if (!parent.isValid()) {
        parentItem = _rootItem;
    } else {
        parentItem = static_cast<TreeItem*>(parent.internalPointer());
    }

    return parentItem->childCount();
}

QHash<int, QByteArray> TreeModel::roleNames() const {
    return _roleNameMapping;
}

Q_INVOKABLE void TreeModel::loadFromFile(const QString& filename) {

    beginResetModel();

    QFile file(filename);
    if (!file.exists()) {
        qCritical() << "TreeModel::loadFromFile, failed to open file" << filename;
    } else if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "TreeModel::loadFromFile, failed to open file" << filename;
    } else {
        qDebug() << "TreeModel::loadFromFile, success opening file" << filename;
        QByteArray contents = file.readAll();
        QJsonParseError error;
        auto doc = QJsonDocument::fromJson(contents, &error);
        if (error.error != QJsonParseError::NoError) {
            qCritical() << "TreeModel::loadFromFile, failed to parse json, error" << error.errorString();
        } else {
            QJsonObject obj = doc.object();

            // version
            QJsonValue versionVal = obj.value("version");
            if (!versionVal.isString()) {
                qCritical() << "TreeModel::loadFromFile, bad string \"version\"";
                return;
            }
            QString version = versionVal.toString();

            // check version
            if (version != "1.0" && version != "1.1") {
                qCritical() << "TreeModel::loadFromFile, bad version number" << version << "expected \"1.0\" or \"1.1\"";
                return;
            }

            // root
            QJsonValue rootVal = obj.value("root");
            if (!rootVal.isObject()) {
                qCritical() << "TreeModel::loadFromFile, bad object \"root\"";
                return;
            }

            QList<QVariant> columnData;
            columnData << QString("root");
            columnData << QString("root");
            columnData << QString("root");

            // create root item
            _rootItem = new TreeItem(columnData);
            _rootItem->appendChild(loadNode(rootVal.toObject()));
        }
    }

    endResetModel();
}

TreeItem* TreeModel::loadNode(const QJsonObject& jsonObj) {

    // id
    auto idVal = jsonObj.value("id");
    if (!idVal.isString()) {
        qCritical() << "loadNode, bad string \"id\"";
        return nullptr;
    }
    QString id = idVal.toString();

    // type
    auto typeVal = jsonObj.value("type");
    if (!typeVal.isString()) {
        qCritical() << "loadNode, bad object \"type\", id =" << id;
        return nullptr;
    }
    QString typeStr = typeVal.toString();

    // data
    auto dataValue = jsonObj.value("data");
    if (!dataValue.isObject()) {
        qCritical() << "AnimNodeLoader, bad string \"data\", id =" << id;
        return nullptr;
    }
    auto dataObj = dataValue.toObject();

    // output joints
    std::vector<QString> outputJoints;
    auto outputJoints_VAL = dataObj.value("outputJoints");
    if (outputJoints_VAL.isArray()) {
        QJsonArray outputJoints_ARRAY = outputJoints_VAL.toArray();
        for (int i = 0; i < outputJoints_ARRAY.size(); i++) {
            outputJoints.push_back(outputJoints_ARRAY.at(i).toString());
        }
    }

    QList<QVariant> columnData;
    columnData << id;
    columnData << typeStr;
    columnData << dataValue.toVariant();

    // create node
    TreeItem* node = new TreeItem(columnData);

    // children
    auto childrenValue = jsonObj.value("children");
    if (!childrenValue.isArray()) {
        qCritical() << "AnimNodeLoader, bad array \"children\", id =" << id;
        return nullptr;
    }
    auto childrenArray = childrenValue.toArray();
    for (const auto& childValue : childrenArray) {
        if (!childValue.isObject()) {
            qCritical() << "AnimNodeLoader, bad object in \"children\", id =" << id;
            return nullptr;
        }
        TreeItem* child = loadNode(childValue.toObject());
        if (child) {
            node->appendChild(child);
        } else {
            return nullptr;
        }
    }

    return node;
}



