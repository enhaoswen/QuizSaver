#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "the_best_json.h"
#include "mem.h"
#include "handle_info.h"
#include "windowmanager.h"
#include "blureffect.h"
#include <QCoreApplication>
#include <filesystem>
#include <QQmlContext>
#include <map>
#include <QPainterPath>
#include <QRegion>
#include <fstream>
#include <QWindow>
using namespace std;

bool isFileEmpty(const string& path) {
    ifstream file(path, ios::ate | ios::binary);
    if (!file.is_open()) {
        return true;
    }

    if (file.tellg() == 0){
        file.close();
        filesystem::remove("C:/Vocab/setting.json");

        return true;
    }
    return false;
}
int main(int argc, char *argv[]){

    QQuickWindow::setDefaultAlphaBuffer(true);

    if (isFileEmpty("C:/Vocab/setting.json")) {

        filesystem::create_directories("C:/Vocab");

        ofstream file("C:/Vocab/setting.json");

        vector<pair<string,string>> data;

        data.push_back({"opacity","150"});
        data.push_back({"theme","1"});
        data.push_back({"img_path", "file:///C:\\coding\\qt\\QuizSaver\\img_1.jpg"});
        data.push_back({"img_changed","F"});
        data.push_back({"blur","50"});

        the_best_json best_json;
        best_json.set_file_path("C:/Vocab/setting.json");
        best_json.write_json(data);

    }

    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName("aims");
    QCoreApplication::setApplicationName("QS");

    QQuickWindow::setDefaultAlphaBuffer(true);

    qmlRegisterType<BlurEffect>("App", 1, 0, "BlurEffect");

    QQmlApplicationEngine engine;
    QObject::connect(&engine,&QQmlApplicationEngine::objectCreationFailed,&app,[]() { QCoreApplication::exit(-1); },Qt::QueuedConnection);

    Mem mem;
    HandleInfo handleinfo;
    BlurEffect blurEffect;
    BlurEffect blurEffect_o;
    BlurEffect blurEffect_v;

    engine.rootContext()->setContextProperty("mem", &mem);
    engine.rootContext()->setContextProperty("blurEffect", &blurEffect);
    engine.rootContext()->setContextProperty("help_blurEffect", &blurEffect_o);
    engine.rootContext()->setContextProperty("vocab_blurEffect", &blurEffect_v);
    engine.rootContext()->setContextProperty("handleinfo", &handleinfo);
    engine.loadFromModule("QuizSaver", "Main");

    QObject *rootObject = engine.rootObjects().first();
    QQuickWindow *mainWin = qobject_cast<QQuickWindow *>(rootObject);
    auto childWin = mainWin->findChild<QQuickWindow*>("blur_layer");
    WindowManager wm(mainWin, childWin);

    engine.rootContext()->setContextProperty("windowManager", &wm);

    QObject::connect(&mem, &Mem::my_blurChanged, &blurEffect, [&](int newBlur){
        blurEffect.setBlurStrength(newBlur);
        blurEffect.setEnabled(newBlur > 0);
        blurEffect_o.setBlurStrength(newBlur);
        blurEffect_o.setEnabled(newBlur > 0);
        blurEffect_v.setBlurStrength(newBlur);
        blurEffect_v.setEnabled(newBlur > 0);
    });


    return app.exec();
}
