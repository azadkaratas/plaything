#include "jsonDataReader.h"

JsonDataReader::JsonDataReader(QObject *parent) : QObject(parent)
{
}

void JsonDataReader::readJsonFile(const QString &filePath)
{
    QString adjustedPath = filePath;
    if (adjustedPath.startsWith("qrc:/")) {
        adjustedPath = ":" + adjustedPath.mid(4);
    }

    QFile file(adjustedPath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Could not open JSON file:" << adjustedPath;
        m_dataLoaded = false;
        emit dataLoadedChanged();
        return;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "JSON parse error:" << parseError.errorString();
        m_dataLoaded = false;
        emit dataLoadedChanged();
        return;
    }

    if (!doc.isObject()) {
        qWarning() << "JSON document is not an object";
        m_dataLoaded = false;
        emit dataLoadedChanged();
        return;
    }

    QJsonObject rootObj = doc.object();
    QJsonArray gamesArray = rootObj["games"].toArray();

    QVariantList gamesList;
    for (const QJsonValue &value : gamesArray) {
        gamesList.append(value.toObject().toVariantMap());
    }

    m_dataLoaded = true;
    emit dataLoadedChanged();
    emit jsonDataReady(gamesList);
}