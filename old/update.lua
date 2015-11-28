JSON = (loadfile ":dungeon/apis/JSON.lua")()

local newFiles = 0

function downloadGitHubFile(fileURL)
 local file = http.get(fileURL)
 local content = file.readAll()
 file.close() --Just in case
 local files = JSON:decode(content)
 for i=1,#files do
  if(files[i]["type"] == "dir")then
   downloadGitHubFile(files[i]["url"])
  else
   local isSame = checkIfFileIsSame(files[i]["download_url"],files[i]["path"])
   -- Do not list updated and github-files.
   if(not isSame and string.sub(files[i]["name"],1,4)~=".git")then
    if(isSame==nil)then 
     term.setTextColor(colors.red)
    else
     term.setTextColor(colors.orange)
	end
	write(files[i]["path"].."\n")
   end
  end
 end
end

function checkIfFileIsSame(_fileA,_fileB)
 if(fs.exists(":dungeon/".._fileB))then
  local file = http.get(_fileA)
  local data1 = file.readAll()
  file.close()
 
  local version = fs.open(":dungeon/".._fileB,"r")
  local data2 = version.readAll()
  version.close()
 
  return (data1==data2)
 else
  return nil
 end
end


local url = "https://api.github.com/repos/wergat/DungeonMap/contents/"
downloadGitHubFile(url)
