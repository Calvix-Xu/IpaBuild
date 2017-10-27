#!/bin/bash
#工程路径
projectPath="/Users/calvix/Desktop/gitlab/CEIS"
#构建输出路径
buildPath=$projectPath/build
#文件输出路径
archivePath=$projectPath/archive
#ipa包输出路径
exportIpaPath=$projectPath/ipa
#证书标志符 查看方法，打开你的钥匙串访问->选中其中一个证书->右键->显示简介，把标题复制出来就可以了，就是标题的值
certificateIdentity="iPhone Developer: Jun Liu (2MTRQ779RS)"
#描述文件uuid 查看方法:找到相应的provisioning，终端执行 /usr/bin/security cms -D -i 098a87e3-11fe-463d-75aa-12345678adba.mobileprovision，查看所有信息
#098a87e3-11fe-463d-75aa-12345678adba是文件名 
provisioningUUID="63138fa9-7971-4d9a-ae63-42ac064e811a"
echo "工程目录："$projectPath
#使用xcodebuild构建
echo "进入 "$projectPath
cd $projectPath
echo "开始构建..."

xcodebuild -scheme CEISProject -configuration Release clean build archive -archivePath ${archivePath}/archive.xcarchive SYMROOT=${buildPath} CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY="${certificateIdentity}" PROVISIONING_PROFILE=${provisioningUUID}
#判断编译结果
if test $? -eq 0
then
echo "~~~~~~~~~~~~~~~~~~~编译成功~~~~~~~~~~~~~~~~~~~"
echo "build 路径: ${buildPath}"
echo "archive 路径: ${archivePath}"
echo "开始生成ipa包..."
else
echo "~~~~~~~~~~~~~~~~~~~编译失败~~~~~~~~~~~~~~~~~~~" 
exit 1
fi

xcodebuild -exportArchive -archivePath ${archivePath}/archive.xcarchive -exportPath ${exportIpaPath}/ipa -exportOptionsPlist exportOptionsPlist.plist

#判断生成ipa结果
if test $? -eq 0
then
echo "~~~~~~~~~~~~~~~~~~~生成ipa成功~~~~~~~~~~~~~~~~~~~"
echo "恭喜你 成功导出ipa！！！"
echo "ipa 路径: ${exportIpaPath}"
else
echo "~~~~~~~~~~~~~~~~~~~生成ipa失败~~~~~~~~~~~~~~~~~~~" 
echo "\n" 
exit 1
fi
