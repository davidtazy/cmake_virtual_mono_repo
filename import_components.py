import argparse
import os
import webbrowser


def trim_str(str):
    s= str.strip('\n')
    s = s.strip('\r')
    s = s.strip()
    return s

def load_target_list(path):
    target_file = os.path.join(path,'component_list.csv')
    if not os.path.exists(target_file):
        raise ValueError("target_file %s doenst exists"%(target_file))

    target_list=[]
    with open(target_file) as openfileobject:
        for line in openfileobject:
            target_list.append(trim_str(line))

    if len(target_list) is 0:
        raise ValueError("target_file %s is empty" % (target_file))

    return target_list


def is_valid_depend(str):
    ignore = ['PUBLIC','PRIVATE','Qt5']

    for ign in ignore:
        if str.startswith(ign):
            return False
    return True


def decode_line(line):

    depends=[]

    elements = line.split(";")
    path = elements[0];
    for num,dep in enumerate(elements):
        if num is 0:
            continue
        if is_valid_depend(dep):
            depends.append(dep)

    return path,depends


def load_depend_list(path):
    depend_file = os.path.join(path, 'target_list.csv')
    if not os.path.exists(depend_file):
        raise ValueError("depend_file %s doenst exists" % (depend_file))

    dico={}

    with open(depend_file) as openfileobject:
        for line in openfileobject:
            path,depends = decode_line(trim_str(line))

            if not dico.has_key(path):
                dico[path]=[]

            for dep in depends:
                dico[path].append(dep)

    return dico


def insert_line_in_file(filename, lines, after):

    f = open(filename, "r")
    contents = f.readlines()
    f.close()

    for num,line in enumerate(contents):
        if line.startswith("import"):
            print ("skip %s - import already done" % filename)
            return

    index_to_insert=-1
    for num,line in enumerate(contents):
        if line.startswith(after):
            index_to_insert = num
            break

    if index_to_insert < 0:
        raise ValueError("cannot find %s in file %s" % (after,filename ))

    contents.insert(index_to_insert +1, lines)

    f = open(filename, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

def generate_import_lines(depends):
    lines =""
    for dep in depends:
        lines += "import(%s)\n" % dep
    return lines



def add_import_to_cmakelist(depend_dico):

    for path in depend_dico.keys():
        cmakelist = os.path.join(path,"CMakeLists.txt")
        if not os.path.exists(cmakelist):
            raise ValueError("cmakelist %s doenst exists" % (cmakelist))
        print("modifying %s" % cmakelist)
        insert_line_in_file(cmakelist, generate_import_lines(depend_dico[path]),"project")




def main():

    parser = argparse.ArgumentParser()
    parser.add_argument("path", help="directory")
    args = parser.parse_args()

    #target_list = load_target_list(args.path)
    depend_dico = load_depend_list(args.path)

    add_import_to_cmakelist(depend_dico)




if __name__ == '__main__':
    main()