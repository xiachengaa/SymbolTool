import os
import os.path

def contains_str(ori_str, str):
    ori_str_low = ori_str.lower()
    str_low = str.lower()
    if str_low in ori_str_low:
        return True
    else:
        return False

def main():
    excel_path = raw_input("1234567489")
    dsym_file = "";
    for filename in os.listdir(os.getcwd()):
        # space resolved
        filename = filename.replace(" ", "\ ")
        # symbol
        if contains_str(filename,".app.dSYM"):
            dsym_file = filename
        filename_pure = os.path.splitext(filename)[0]
        extend = os.path.splitext(filename)[1]
        if extend == '.crash' or extend == '.ips':
            print '\nreading:%s...\n' % filename
            evi_cmd = 'export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer'
            cmd = '%s;./symbolicatecrash %s %s > %s_sym.txt' % (evi_cmd,filename,dsym_file,filename_pure)
            print  cmd
            os.system(cmd)

        # print filename
    print 'completed'

if __name__ == '__main__':
    main()


