source 'git@github.com:CocoaPods/Specs.git'
source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs-thirdpart.git'
source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs.git'
source 'git@gitlab.emas-ha.cn:root/emas-specs.git'
#source 'git@gitlab.alibaba-inc.com:alipods/specs.git'

# WeexAceChart
source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/weex-chart.git'
source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/native-chart.git'

# WeexComponents
source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/weex-common.git'
source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/native-common.git'

#project 'EMASDemo.xcodeproj'

platform :ios

target 'EMASDemo' do

platform:ios, '8.0'


    # --通用库
    pod  'UserTrack',        '6.3.5.100005-poc'
    pod  'Reachability',     '3.2'
    pod  'FMDB',             '2.7.2'
    pod  'NetworkSDK',       '10.0.4.2'
    pod  'tnet',             '10.2.0'
    pod  'AliEMASConfigure',  '0.0.1.13'

    # --ACCS(通用库 -> ACCS)
    pod  'TBAccsSDK',         '10.0.7'
    #pod  'TBAccsSDK',  :path=>  '/Users/wuchen.xj/gitemas/tbaccssdk/'
    
    # --PUSH(通用库 -> PUSH)
    pod  'PushCenterSDK',     '10.0.1'
    #pod  'PushCenterSDK',  :path=>  '/Users/wuchen.xj/gitemas/pushcentersdk/'
    
    # --网关(通用库-> 网关)
    pod  'MtopSDK',          '10.0.6'
    pod  'mtopext/MtopCore', '10.0.6'
    
    # --远程配置
    pod 'orange','10.0.0'
    
    # --高可用(通用库-> ACCS -> 高可用)
    pod  'AliHAAdapter4poc',   '10.0.5.2'    
    #pod  'ZipArchive', '~> 1.4.0'
    
    # --Weex(通用库-> 高可用 -> 网关 -> Weex)
    pod 'WeexSDK', '0.18.3.18-EMAS'
    pod 'ZCache', '10.0.3'
    #pod 'ZipArchive', '~> 1.4.0'
    pod 'SDWebImage', '3.7.5'
    pod 'DynamicConfiguration', '10.0.4'
    pod 'DynamicConfigurationAdaptor', '10.0.4'

    #weex开源组件
    pod 'BindingX', '~> 1.0.2'
    
    #weex商业图表
    pod 'WeexAceChart'
    
    #weex商业组件
    pod 'EmasWeexComponents', '0.0.4'
    
    # EMASWeex
    pod 'EMASWeex', '1.3.0'
    pod 'WXDevtool', '~> 0.16.3' ,:configurations => ['Debug']
    pod 'CYLTabBarController', '~> 1.17.14'
    pod 'SocketRocket'
    
    # WindVane
    pod 'WindVane', '1.1.0'
    
    # --热修复
    pod 'AlicloudLua', '5.1.4.2'
    pod 'AlicloudUtils', '1.3.4'
    pod 'ZipArchive', '~> 1.4.0'
    pod 'AlicloudHotFixDebugEmas', '~> 1.0.5'
    
    # 数据分析
    pod 'EMASMAN', '10.0.0'    
    
    pod 'EMASFirstBundle', '3.0.8'
    
    
end
