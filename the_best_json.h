#ifndef THE_BEST_JSON_H
#define THE_BEST_JSON_H

#include<map>
#include<iostream>
#include<fstream>
#include<vector>
#include<regex>
using namespace std;

class the_best_json{
public:
    void set_file_path(string path);
    void write_json(const vector<pair<string,string>>& data, string fileFath = "C:/Vocab/setting.json");
    vector<pair<string,string>> read_json();
    string find_info(string key, vector<pair<string,string>>);

private:
    string file_path = "C:/Vocab/setting.json";
    string escape(const string& s);
    string unescape(const string& s);
};

#endif // THE_BEST_JSON_H
