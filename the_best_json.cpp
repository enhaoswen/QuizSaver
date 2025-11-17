#include "the_best_json.h"

void the_best_json::set_file_path(string path){
    file_path = path;
}

string the_best_json::escape(const string& s) {
    std::string res;
    for (char c : s) {
        if (c == '"') res += "\\\"";
        else if (c == '\\') res += "\\\\";
        else res += c;
    }
    return res;
}

string the_best_json::unescape(const string& s) {
    string res;
    bool escape = false;
    for (char c : s) {
        if (escape) {
            if (c == '"' || c == '\\')
                res += c;
            else
                res += '\\', res += c;
            escape = false;
        } else if (c == '\\') {
            escape = true;
        } else {
            res += c;
        }
    }
    return res;
}

void the_best_json::write_json(const vector<pair<string, string> > &data, string filePath){
    ofstream file{filePath};
    file<<"{\n";

    int size_of_data = data.size();
    int index  = 1;

    for (pair<string,string>temp_info : data){
        file << "    \"" << escape(temp_info.first) << "\": \"" << escape(temp_info.second) << "\"";
            if (index != size_of_data) file<<",";
                file<<"\n";
                ++index;
    }

    file<< "}";
}

vector<pair<string, string>> the_best_json::read_json() {
    vector<pair<string, string>> temp_info;
    ifstream file(file_path);
    string line;
    while (getline(file, line)) {
        size_t quote1 = line.find('"');
        size_t quote2 = line.find('"', quote1 + 1);
        size_t colon  = line.find(':', quote2);
        size_t quote3 = line.find('"', colon);
        size_t quote4 = line.find('"', quote3 + 1);
        if (quote1 != string::npos && quote2 != string::npos && quote3 != string::npos && quote4 != string::npos) {
            string key = unescape(line.substr(quote1 + 1, quote2 - quote1 - 1));
            string value = unescape(line.substr(quote3 + 1, quote4 - quote3 - 1));
            temp_info.push_back({ key, value });
        }
    }
    return temp_info;
}

string the_best_json::find_info(string key,vector<pair<string,string>>data){
    for (pair<string,string>temp_info : data){
        if (temp_info.first == key) return temp_info.second;
    }
    return "Error";
}


