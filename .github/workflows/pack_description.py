import datetime
import json
import subprocess

def load_json() -> dict:
    with open("pack.mcmeta","r") as f:
        return json.load(f)
def write_json(data):
    with open("pack.mcmeta","w") as f:
        json.dump(data,f,indent=2)

def main():
    jsonobj = load_json()
    commit_id = subprocess.run(["git","rev-parse","--short","HEAD"],capture_output=True, text=True).stdout.strip()
    existing_description = jsonobj.get("pack").get("description")
    
    now = datetime.datetime.now()

    new_description = f"{existing_description}\nBUILD: {commit_id}({now.strftime("%Y-%m-%d %H:%M:%S")})"
    jsonobj["pack"]["description"] = new_description
    write_json(jsonobj)




if __name__ == "__main__":
    main()