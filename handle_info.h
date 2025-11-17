#ifndef VOCABCARD_H
#define VOCABCARD_H

#include <QObject>
#include<iostream>
#include<string>
#include<fstream>
#include<vector>
#include <QVariantList>
#include <QDir>
#include <QFileInfoList>
#include<QString>
#include <QDebug>
#include<map>
#include <QList>
#include <QVariantMap>
using namespace std;

class HandleInfo : public QObject{
    Q_OBJECT

public:
    Q_INVOKABLE void getRes();
    Q_INVOKABLE QString getPath();
    Q_INVOKABLE QString getForm();
    Q_INVOKABLE void creatForm();
    Q_INVOKABLE bool checkForm(QString form);
    Q_INVOKABLE void setRes(vector<string> res);
    Q_INVOKABLE void setForm(QString form);
    Q_INVOKABLE void setPath(QString path);
    Q_INVOKABLE void setTitle(QString title);
    Q_INVOKABLE void generateJsonFile();
    Q_INVOKABLE void generateFilePath();
    Q_INVOKABLE QList<QVariantMap> getFolderInfo();

    Q_INVOKABLE QVariantList processMessage(const QString &msg);
    Q_INVOKABLE QString init_card();
    Q_INVOKABLE void load_card();

private:
    string CForm, CPath,CTitle,FPath;
    vector<string> CRes;
    vector<pair<string,string>>info;
    size_t index = 0;
    size_t max_index;

signals:
    void responseReady(const QString &result);
};

#endif // VOCABCARD_H
