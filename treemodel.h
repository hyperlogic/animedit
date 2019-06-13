//
//  TreeModel
//
//  Created by Anthony Thibault on 6/5/2019
//  Copyright 2019 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html
//

#ifndef hifi_TreeModel_h
#define hifi_TreeModel_h

#include <QAbstractItemModel>
#include <QJsonObject>
#include <QModelIndex>
#include <QObject>
#include <QString>
#include <QVariant>

class TreeItem;

class TreeModel : public QAbstractItemModel {
    Q_OBJECT

public:
    enum TreeModelRoles
    {
        TreeModelRoleName = Qt::UserRole + 1,
        TreeModelRoleType
    };

    explicit TreeModel(QObject* parent = 0);
    ~TreeModel() override;

    /* QAbstractItemModel interface */
    QVariant data(const QModelIndex& index, int role) const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QModelIndex index(int row, int column, const QModelIndex& parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex& index) const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    int columnCount(const QModelIndex& parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void loadFromFile(const QString& filename);

private:
    QVariant newCustomType(const QString& text);
    TreeItem* loadNode(const QJsonObject& jsonObj);

    TreeItem* _rootItem;
    QHash<int, QByteArray> _roleNameMapping;
};

#endif
