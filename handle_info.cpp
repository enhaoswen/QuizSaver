#include<regex>
#include"the_best_json.h"
#include "handle_info.h"
using namespace std;
the_best_json t;

std::string cleanString(const std::string &s) {
    std::string result;
    for (unsigned char c : s) {
        if (c >= 32 && c != 127) {
            result.push_back(c);
        }
    }
    return result;
}

void HandleInfo::getRes(){
    if (CPath == ""){
        cout<<"no path"<<endl;
        exit(-1);
    }

    string line;
    ifstream file(CPath.substr(8));
    while(getline(file, line)) CRes.push_back(line);
}

void HandleInfo::creatForm() {

    if (CForm == "") {
        cout<<"no form"<<endl;
        exit(-1);
    }

    regex pattern1("\\(num\\)");
    CForm = regex_replace(CForm, pattern1, "(\\d*)");

    regex pattern2("\\(vocab\\)");
    CForm = regex_replace(CForm, pattern2, "(\\w*)");

    regex pattern3("\\(meaning\\)");
    CForm = regex_replace(CForm, pattern3, "(\\w*)");
}

bool HandleInfo::checkForm(QString form){
    string Sform = cleanString(form.toStdString());
    std::string lowerForm = Sform;
    std::transform(lowerForm.begin(), lowerForm.end(), lowerForm.begin(), ::tolower);

    return lowerForm.find("(meaning)") != std::string::npos &&lowerForm.find("(vocab)")   != std::string::npos;
}

QString HandleInfo::getPath() {return QString::fromStdString(CPath);}
QString HandleInfo::getForm() { return QString::fromStdString(CForm);}

void HandleInfo::setRes(vector<string> res){CRes = res;}
void HandleInfo::setForm(QString form){CForm = form.toStdString();}

void HandleInfo::setPath(QString path){CPath = path.toStdString();}

void HandleInfo::setTitle(QString title){CTitle = title.toStdString();}

void HandleInfo::generateFilePath(){FPath = "C:/Vocab/" + CTitle + ".json";}

void HandleInfo::generateJsonFile(){
    regex pattern(CForm);
    smatch match;
    info.clear();
    for (string line : CRes){
        if (regex_match(line,match,pattern)) info.push_back({match[2],match[3]});
    }
    t.write_json(info, FPath);
}

QString HandleInfo::init_card(){
    max_index = info.size();
    return QString::number(index + 1) + "/" + QString::number(max_index);
}

QVariantList HandleInfo::processMessage(const QString &msg){
    if (msg == "1") ++index;
    else if (msg == "2"){
        if (index > 0) --index;
        else index = max_index-1;
    }
    if (index == max_index) index = 0;
    QVariantList list;

    auto p = info[index];
    list.append(QString::fromStdString(p.first));
    list.append(QString::fromStdString(p.second));
    list.append(QString::fromStdString(to_string(index+1) + "/" + to_string(max_index)));

    return list;
}

QList<QVariantMap> HandleInfo::getFolderInfo(){
    QDir dir("C://Vocab");
    QFileInfoList files = dir.entryInfoList(QStringList() << "*.json",QDir::Files);
    QList<QVariantMap> list;
    for (const QFileInfo &f : files) {
        QVariantMap map;
        if (f.fileName() == "setting.json") continue;
        map["name"] = f.fileName().replace(".json","");
        map["path"] = f.absoluteFilePath();
        list.append(map);
        qDebug() << f.fileName().replace(".json","")<<"\n";
    }

    return list;
}

void HandleInfo::load_card(){
    t.set_file_path(CPath);
    info = t.read_json();
}
