#!/bin/bash

#脚手架生成脚本
#脚本依赖：
#1. mac系统必须使用GUN的sed，使用命令安装gnu-sed到/usr/local/bin/sed，替换系统FreeBSD的sed. brew install gnu-sed --with-default-names
#   安装完成后执行sed应该看到“GNU sed home page”几个关键字，如果不是说明还是使用的macos系统/usr/bin/sed，需要将/usr/local/bin加入$PATH且在/usr/bin之前
#2. 帮助文档 ./gen_scaffold.sh -h
#3. 命令示例：./gen_scaffold.sh -BUNDLE_ID my.bundle.id -SDK_CONFIG_APP_KEY appkey -SDK_CONFIG_APP_SECRET appsecret -SDK_CONFIG_CHANNEL_ID 1001@POC_iOS_1.0.0 -SDK_CONFIG_USE_HTTP false -SDK_CONFIG_ACCS_DOMAIN accs.com -SDK_CONFIG_MTOP_DOMAIN mtop.com -SDK_CONFIG_ZCACHE_PREFIX http://zcache.com/prefex -SDK_CONFIG_HOTFIX_URL http://hotfix.com -SDK_CONFIG_HA_OSS_BUCKET ha-oss-bucket -SDK_CONFIG_HA_ADASH_DOMAIN adash.com -APP_NAME myapp -MAVEN_BASE_GROUP com.my -WEEX_UI_SDK 1 -WEEX_BUSINESS_COMPONENTS 1 -WEEX_BUSINESS_CHARTS 1 -WEEX_PAGE_TAB_SIZE 5 -SCAFFOLD_TYPE 1

set -e

#包名
APP_NAME=""
#bundleID
BUNDLE_ID=""

#SDK_CONFIG系统配置
SDK_CONFIG_APP_KEY=""
SDK_CONFIG_APP_SECRET=""
SDK_CONFIG_CHANNEL_ID=""
SDK_CONFIG_USE_HTTP=""
SDK_CONFIG_ACCS_DOMAIN=""
SDK_CONFIG_MTOP_DOMAIN=""
SDK_CONFIG_ZCACHE_PREFIX=""  # ZCache.URL
SDK_CONFIG_HOTFIX_URL=""  # Hotfix.URL
SDK_CONFIG_ORANGE_DOMAIN=""  # RemoteConfig.Domain
SDK_CONFIG_HA_OSS_BUCKET=""  #HA.OSSBucketName
SDK_CONFIG_HA_ADASH_DOMAIN=""  # HA.UniversalHost
SDK_CONFIG_HA_PUBLIC_KEY=""    # HA.RSAPublicKey

#脚手架组合类型 1->native 2->跨平台研发weex 4->跨平台研发H5
SCAFFOLD_TYPE=""

#Weex外围SDK配置，传入非""表示启用
WEEX_UI_SDK=""
WEEX_BUSINESS_COMPONENTS=""
WEEX_BUSINESS_CHARTS=""

#Weex Native页面配置
WEEX_PAGE_TAB_SIZE=""

#打印帮助文档
printHelp() {
    echo "scaffold generate script."
    echo
    echo "options:"
    echo "   -h help."

    echo "   -BUNDLE_ID                         bundleId，从控制台读取。必填"
    echo "   -APP_NAME                          appName，从控制台读取。必填"
    echo "   -SDK_CONFIG_APP_KEY                AppKey，从控制台读取。必填"
    echo "   -SDK_CONFIG_APP_SECRET             AppSecret，从控制台读取。必填"
    echo "   -SDK_CONFIG_CHANNEL_ID             ChannelID。必填"
    echo "   -SDK_CONFIG_USE_HTTP               UseHTTP，从控制台读取。可选"
    echo "   -SDK_CONFIG_ACCS_DOMAIN            ACCS Domain, 从控制台读取。可选"
    echo "   -SDK_CONFIG_MTOP_DOMAIN            MTOP Domain，从控制台读取。可选"
    echo "   -SDK_CONFIG_ZCACHE_PREFIX          ZCache URL，从控制台读取。可选"
    echo "   -SDK_CONFIG_ORANGE_DOMAIN          RemoteConfig Domain，从控制台读取。可选"
    echo "   -SDK_CONFIG_HOTFIX_URL             Hotfix URL，从控制台读取。可选"
    echo "   -SDK_CONFIG_HA_OSS_BUCKET          HA.OSSBucketName，从控制台读取。可选"
    echo "   -SDK_CONFIG_HA_ADASH_DOMAIN        HA.UniversalHost，从控制台读取。可选"
    echo "   -SDK_CONFIG_HA_PUBLIC_KEY          HA.RSAPublicKey，从控制台读取。可选"

    echo "   -WEEX_UI_SDK                       启用weex-ui SDK时设置为1。可选"
    echo "   -WEEX_BUSINESS_COMPONENTS          启用商业组件SDK时设置为1。可选"
    echo "   -WEEX_BUSINESS_CHARTS              启用商业图表SDK时设置为1。可选"

    echo "   -WEEX_PAGE_TAB_SIZE                Weex首页Tab数量，0表示首页非weex，1表示为单页结构，2-5为tab页结构。可选"
    echo "   -SCAFFOLD_TYPE                     脚手架组合类型 1->native 2->跨平台研发weex 4->跨平台研发H5。可选"

    echo
}

escapeSpecialChars() {
    # &替换为\&
    TEMP=${1//&/\\&}
    # /替换为\/
    TEMP=${TEMP//\//\\/}
    echo $TEMP
}

checkParameters() {
    echo "start check parameters ..."
    REQUIRED_CONFIGS=(BUNDLE_ID SDK_CONFIG_APP_KEY SDK_CONFIG_APP_SECRET SDK_CONFIG_CHANNEL_ID)
    for config in ${REQUIRED_CONFIGS[@]}
    do
        if [ "${!config}" == "" ]; then
            echo "$config is required."
            exit 1
        fi
    done
    echo "check parameters done."
}

modifyNativeSDk() {
    echo "starting modify native SDK ..."
    SDK_PATH="AliyunEmasServices-Info.plist"
    #替换匹配的下一行
    if [ "$SDK_CONFIG_APP_KEY" != "" ]; then
        #如果">AppKey<"被匹配，则n命令移动到匹配行的下一行，替换这一行的参数
        sed -i "/>AppKey</{n; s/<string>.*/<string>$SDK_CONFIG_APP_KEY<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_APP_SECRET" != "" ]; then
        sed -i "/>AppSecret</{n; s/<string>.*/<string>$SDK_CONFIG_APP_SECRET<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_CHANNEL_ID" != "" ]; then
        sed -i "/>ChannelID</{n; s/<string>.*/<string>$SDK_CONFIG_CHANNEL_ID<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_ACCS_DOMAIN" != "" ]; then
        #如果">ACCS<"被匹配，则n命令移动到匹配行的下3行，替换这一行的Domain信息
        sed -i "/>ACCS</{n;n;n; s/<string>.*/<string>$SDK_CONFIG_ACCS_DOMAIN<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_MTOP_DOMAIN" != "" ]; then
        sed -i "/>MTOP</{n;n;n; s/<string>.*/<string>$SDK_CONFIG_MTOP_DOMAIN<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_ZCACHE_PREFIX" != "" ]; then
        sed -i "/>ZCache</{n;n;n; s/<string>.*/<string>$SDK_CONFIG_ZCACHE_PREFIX<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_HA_OSS_BUCKET" != "" ]; then
        sed -i "/>OSSBucketName</{n; s/<string>.*/<string>$SDK_CONFIG_HA_OSS_BUCKET<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_HA_ADASH_DOMAIN" != "" ]; then
        sed -i "/>UniversalHost</{n; s/<string>.*/<string>$SDK_CONFIG_HA_ADASH_DOMAIN<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_HA_PUBLIC_KEY" != "" ]; then
        sed -i "/>RSAPublicKey</{n; s/<string>.*/<string>$SDK_CONFIG_HA_PUBLIC_KEY<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_HOTFIX_URL" != "" ]; then
        sed -i "/>Hotfix</{n;n;n; s/<string>.*/<string>$SDK_CONFIG_HOTFIX_URL<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_ORANGE_DOMAIN" != "" ]; then
        sed -i "/>RemoteConfig</{n;n;n; s/<string>.*/<string>$SDK_CONFIG_ORANGE_DOMAIN<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_USE_HTTP" != "" ]; then
        sed -i "/>UseHTTP</{n; s/<.*\/>/<$SDK_CONFIG_USE_HTTP\/>/g; }" $SDK_PATH
    fi

    echo "modify native SDK done."
}


modifyWeexSDK() {
    echo "start modify Weex SDK ..."

    PODFILE_PATH="Podfile"

    #weex-ui sdk（bindingx)
    if [ "$WEEX_UI_SDK" == "" ]; then
        #注释：将pod替换成#pod
        sed -i "/pod 'BindingX'/{ s/pod/#pod/g }" $PODFILE_PATH
    else
        #取消注释：将#替换掉成""
        sed -i "/pod 'BindingX'/{ s/#//g }" $PODFILE_PATH
    fi

    #商业组件SDK
    if [ "$WEEX_BUSINESS_COMPONENTS" == "" ]; then
        #source注释规则：# WeexComponents下两行注释掉
        sed -i "/# WeexComponents/{ n; s/source/#source/g }" $PODFILE_PATH
        sed -i "/# WeexComponents/{ n;n; s/source/#source/g }" $PODFILE_PATH
        #Podfile注释
        sed -i "/pod 'EmasWeexComponents'/{ s/pod/#pod/g }" $PODFILE_PATH
    else
        #取消注释：将#替换掉成""
        #取消source注释规则：# WeexComponents下两行注释掉
        sed -i "/# WeexComponents/{ n; s/#//g }" $PODFILE_PATH
        sed -i "/# WeexComponents/{ n;n; s/#//g }" $PODFILE_PATH
        #取消Podfile注释
        sed -i "/pod 'EmasWeexComponents'/{ s/#//g }" $PODFILE_PATH
        #移动文件
        mv Resource/BusinessSDK/EMASWXSubSDKEngine.m EMASDemo/Weex/EMASWXSubSDKEngine.m
    fi

    #商业图表SDK
    if [ "$WEEX_BUSINESS_CHARTS" == "" ]; then
        #source注释
        sed -i "/# WeexAceChart/{ n; s/source/#source/g }" $PODFILE_PATH
        sed -i "/# WeexAceChart/{ n;n; s/source/#source/g }" $PODFILE_PATH
        #Podfile注释
        sed -i "/pod 'WeexAceChart'/{ s/pod/#pod/g }" $PODFILE_PATH
    else
        #取消注释：将#替换掉成""
        #取消source注释
        sed -i "/# WeexAceChart/{ n; s/#//g }" $PODFILE_PATH
        sed -i "/# WeexAceChart/{ n;n; s/#//g }" $PODFILE_PATH
        #取消Podfile注释
        sed -i "/pod 'WeexAceChart'/{ s/#//g }" $PODFILE_PATH
    fi

    #最后删除Resource文件夹
    rm -rf Resource

    echo "modify Weex sdk done."
}

modifyScaffoldType() {
    echo "start modify Scaffold Type ..."
    if [ "$SCAFFOLD_TYPE" != "" ]; then
        sed -i "/>ScaffoldType</{n; s/<integer>.*/<integer>$SCAFFOLD_TYPE<\/integer>/g; }" Scaffold-Info.plist
    fi
    echo "modify Scaffold Type done."
}

modifyWeexNativePage() {
    echo "start modify WEEX native page ..."
    if [ "$WEEX_PAGE_TAB_SIZE" != "" ]; then
        sed -i "/>TabSize</{n; s/<integer>.*/<integer>$WEEX_PAGE_TAB_SIZE<\/integer>/g; }" Scaffold-Info.plist
    fi
    echo "modify Weex native page done."
}

modifyPackageName() {
    echo "start modify package name ..."
    sed -i "/>CFBundleDisplayName</{n; s/<string>.*/<string>$APP_NAME<\/string>/g; }" EMASDemo/Info.plist
    echo "modify package name done."
}

modifyBundleId() {
    echo "start modify bundle id ..."
    sed -i "/>CFBundleIdentifier</{n; s/<string>.*/<string>$BUNDLE_ID<\/string>/g; }" EMASDemo/Info.plist
    echo "modify bundle Id done."
}

while [ $# -gt 0 ];do
    case $1 in
        -h)
            printHelp
            exit 0
            ;;
        -*)
            #字符串截取: $1截取-
            param_name=${1#-}
            shift
            TEMP=`escapeSpecialChars "${1}"`
            eval $param_name='$TEMP'
            shift
            ;;           
    esac
done


#0. 参数检查
checkParameters

#1. native sdk配置修改
modifyNativeSDk

#2. 发布包名修改
modifyPackageName

#3. 修改脚手架类型
modifyScaffoldType

#4. weex外围sdk相关配置
modifyWeexSDK

#5. Weex Native页面配置
modifyWeexNativePage
