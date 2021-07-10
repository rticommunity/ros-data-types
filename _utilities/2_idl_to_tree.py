# 2_idl_to_tree.py - Step 2 helper to convert a merged IDL file
#  with 1-def-per-line into a directory tree of IDL files.
# Started 2020Nov08 Neil Puthuff

import sys
import os

file_header = '''/* 
 * Copyright 2012-2018 Open Source Robotics Foundation 
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); 
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at 
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0 
 * 
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS, 
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
 * See the License for the specific language governing permissions and 
 * limitations under the License. 
 */ 
'''

def add_fmt(iline):
  oline = ""
  indent = 0
  skip = False
  for c in iline:
    if skip == True:
      if c != ' ':
        if c == '}':
          indent -= 2
        oline = oline + (" " * indent) + c
        skip = False
    elif c == '{':
      indent += 2
      oline = oline + c + '\n'
      skip = True
    elif c == ';':
      oline = oline + c + '\n'
      skip = True
    else:
      oline = oline + c
  return oline

with open(sys.argv[1], 'r') as idl_in:
  line_in = idl_in.readline()
  type_cnt = 1
  while line_in:
    modName = ''
    subDir = ''
    typeName = ''
    includeFiles = set()
    wlist = line_in.split()
    if wlist[0] == "module":
      modName = wlist[1]
      if wlist[3] == "module":
        subDir = wlist[4]
        
      wcnt = 0
      for w in wlist:
        if w == "struct":
          typeName = wlist[wcnt+1].rstrip('_')
        wcnt += 1
      
        if "::" in w:
          tmpW = w
          if "sequence<" in tmpW:
            tmpW = tmpW[9:].strip(">")
            if "," in tmpW:
              tmpW = tmpW[0:tmpW.rfind(',')-1]
          incParts = tmpW.split('::')
          incFile = "{}/{}/{}.idl".format(incParts[0], incParts[1], incParts[3].rstrip('_'))
          includeFiles.add(incFile)
          
      type_cnt += 1
      
      # create directories if they don't already exist
      if not os.path.exists('./{}'.format(modName)):
        os.makedirs('./{}'.format(modName))
      if not os.path.exists('./{}/{}'.format(modName, subDir)):
        os.makedirs('./{}/{}'.format(modName, subDir))

      # create the IDL type file
      f_idl = open('./{}/{}/{}.idl'.format(modName, subDir, typeName), "w")

      # write the file comment header
      f_idl.write("{}\n".format(file_header))

      # make the ifndef string
      ifndef_string = "__{}__{}__{}__idl".format(modName, subDir, typeName)
      f_idl.write("#ifndef {}\n".format(ifndef_string))
      f_idl.write("#define {}\n\n".format(ifndef_string))
      
      # add any include files needed
      if len(includeFiles) > 0:
        for incF in includeFiles:
          f_idl.write("#include \"{}\"\n".format(incF))
        f_idl.write("\n")
        
      # write the data types info
      f_idl.write("{}\n".format(add_fmt(line_in)))
      
      # close the ifndef string
      f_idl.write("#endif // {}\n".format(ifndef_string))
      
      f_idl.close()
              
    line_in = idl_in.readline()
  idl_in.close()
  