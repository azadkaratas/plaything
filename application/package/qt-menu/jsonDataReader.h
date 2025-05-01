#pragma once

#include <QObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QDebug>

class JsonDataReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool dataLoaded READ dataLoaded NOTIFY dataLoadedChanged)

public:
    explicit JsonDataReader(QObject *parent = nullptr);

    bool dataLoaded() const { return m_dataLoaded; }

    Q_INVOKABLE void readJsonFile(const QString &filePath);

signals:
    void dataLoadedChanged();
    void jsonDataReady(const QVariantList &games);

private:
    bool m_dataLoaded = false;
};