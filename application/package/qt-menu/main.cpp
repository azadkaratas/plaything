#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
//#include <QQuickStyle>
#include <QProcess>
#include <QNetworkInterface>
#include <QDebug>
#include "jsonDataReader.h"

class SystemSettings : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString ipAddress READ ipAddress NOTIFY ipAddressChanged)
    Q_PROPERTY(QString networkStatus READ networkStatus NOTIFY networkStatusChanged)

public:
    explicit SystemSettings(QObject *parent = nullptr) : QObject(parent) {
        updateNetworkInfo(); // Initialize network info
    }

    QString ipAddress() const { return m_ipAddress; }
    QString networkStatus() const { return m_networkStatus; }

public slots:
    void updateNetworkInfo() { 
    }

signals:
    void ipAddressChanged();
    void networkStatusChanged();

private:
    QString m_ipAddress;
    QString m_networkStatus;
};

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    QGuiApplication app(argc, argv);

    // Set application style
    //QQuickStyle::setStyle("Material");

    // Create SystemSettings instance
    SystemSettings systemSettings;
    JsonDataReader jsonReader;

    QQmlApplicationEngine engine;

    // Expose SystemSettings to QML
    engine.rootContext()->setContextProperty("systemSettings", &systemSettings);
    engine.rootContext()->setContextProperty("jsonReader", &jsonReader);

    // Load main QML file
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}

#include "main.moc"