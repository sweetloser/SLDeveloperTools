#
# Be sure to run `pod lib lint SLDeveloperTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SLDeveloperTools'
  s.version          = '0.0.1'
  s.summary          = 'A short description of SLDeveloperTools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sweetloser/SLDeveloperTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sweetloser' => '8244768@qq.com' }  #18272160172@163.com
  s.source           = { :git => 'https://github.com/sweetloser/SLDeveloperTools.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.platform     = :ios, "9.0"
  s.requires_arc = true
  s.static_framework = true

  s.source_files = 'SLDeveloperTools/SLDeveloperTools.h'
  s.dependency 'CTMediatorSLAmway'
  s.dependency 'CTMediatorSLDynamic'

  s.subspec 'SLCategory' do |category|
      category.source_files = 'SLDeveloperTools/SLCategory/*.{h,m}'
      category.dependency 'SLDeveloperTools/SLMacro'
      category.dependency 'MJRefresh'
#      category.dependency 'MMKV'
      category.dependency 'YYText'
      category.frameworks = 'OpenGLES'
  end

  s.subspec 'SLMacro' do |macro|
    macro.source_files = 'SLDeveloperTools/SLMacro/*.h'
  end

  s.subspec 'SLUtilities' do |utils|
    utils.dependency 'SLDeveloperTools/SLMacro'
      utils.dependency 'KTVHTTPCache', '~> 1.1.7'
      utils.dependency 'YYWebImage', '~> 1.0.5'
      utils.dependency 'SDAutoLayout'
      utils.source_files = 'SLDeveloperTools/SLUtilities/*.{h,m}'
  end
#
  s.subspec 'SLWidget' do |widget|
      widget.source_files = 'SLDeveloperTools/SLWidget/*.{h,m}'
      widget.dependency 'SLDeveloperTools/SLMacro'
      widget.dependency 'Masonry'
#      版本更新组件
      widget.subspec 'SLVersionTool' do |vt|
          vt.source_files = 'SLDeveloperTools/SLWidget/SLVersionTool/*.{h,m}'
          vt.dependency 'SLDeveloperTools/SLNetTools'
      end

#      刷新组件
      widget.subspec 'SLRefreshTool' do |rt|
          rt.source_files = 'SLDeveloperTools/SLWidget/SLRefreshTool/*.{h,m}'
          rt.dependency 'SLDeveloperTools/SLCategory'
          rt.dependency 'MJRefresh'
      end
##      无网络 & 无数据 页面
      widget.subspec 'SLBaseEmptyVC' do |et|
          et.source_files = 'SLDeveloperTools/SLWidget/SLBaseEmptyVC/*.{h,m}'
          et.dependency 'SLDeveloperTools/SLBaseClass'
          et.dependency 'SLDeveloperTools/SLNetTools'
      end

#      第三方（QQ、微信）分享组件
      widget.subspec 'SLShareTools' do |st|
        st.source_files = 'SLDeveloperTools/SLWidget/SLShareTools/*.{h,m}'
        st.dependency 'SLDeveloperTools/SLBaseClass'
        st.dependency 'SLDeveloperTools/SLCategory'
      end

#      JXCategoryView（二次封装组件）
      widget.subspec 'SLJXCategoryView'  do |jx|
        jx.source_files = 'SLDeveloperTools/SLWidget/SLJXCategoryView/**/*.{h,m}','SLDeveloperTools/SLWidget/SLJXCategoryView/**/**/*.{h,m}','SLDeveloperTools/SLWidget/SLJXCategoryView/JXCategoryView.h'
      end
#      bannerView
      widget.subspec 'SLBannerTools' do |bt|
        bt.source_files = 'SLDeveloperTools/SLWidget/SLBannerTools/*.{h,m}'
        bt.dependency 'iCarousel'
        bt.dependency 'SLDeveloperTools/SLCategory'
        bt.dependency 'SDWebImage', '= 5.10.0'
      end
      
      widget.subspec 'SLSDCycleScrollView' do |sd|
        sd.source_files = 'SLDeveloperTools/SLWidget/SLSDCycleScrollView/*.{h,m}'
      end

  end

  s.subspec 'SLNetTools' do |netTools|
    netTools.source_files = 'SLDeveloperTools/SLNetTools/*.{h,m}'
    netTools.dependency 'SLDeveloperTools/SLUtilities'
    netTools.dependency 'SLDeveloperTools/SLCategory'
    netTools.dependency 'AFNetworking'
    netTools.dependency 'SDWebImage', '= 5.10.0'
  end

  s.subspec "SLMaskTools" do |maskTools|
    maskTools.source_files = 'SLDeveloperTools/SLMaskTools/*.{h,m}'
    maskTools.dependency 'SLDeveloperTools/SLMacro'
    maskTools.dependency 'SLDeveloperTools/SLCategory'
    maskTools.dependency 'SVProgressHUD'
    maskTools.dependency 'MBProgressHUD'
    maskTools.dependency 'Masonry'
    maskTools.dependency 'lottie-ios', '2.5.3'
  end

  s.subspec "SLVideoWaterMaskTools" do |videoWaterMaskTools|
    videoWaterMaskTools.source_files = 'SLDeveloperTools/SLVideoWaterMaskTools/*.{h,m}'
    videoWaterMaskTools.dependency 'SLDeveloperTools/SLMaskTools'
    videoWaterMaskTools.dependency 'SLDeveloperTools/SLCategory'
    videoWaterMaskTools.dependency 'SLDeveloperTools/SLMacro'
    videoWaterMaskTools.dependency 'SLDeveloperTools/SLUtilities'
    videoWaterMaskTools.dependency 'GPUImage', '~> 0.1.7'
    videoWaterMaskTools.dependency 'Aspects'
    videoWaterMaskTools.dependency 'YYWebImage', '~> 1.0.5'
    videoWaterMaskTools.frameworks = 'Photos', 'UIKit'
  end

  s.subspec "SLSelectFilter" do |sf|
      sf.source_files = 'SLDeveloperTools/SLSelectFilter/**/*','SLDeveloperTools/SLSelectFilter/*.{h,m}'
      sf.dependency 'SLDeveloperTools/SLMaskTools'
      sf.dependency 'SLDeveloperTools/SLCategory'
      sf.dependency 'SLDeveloperTools/SLMacro'
      sf.dependency 'SLDeveloperTools/SLBaseClass'
      sf.dependency 'SLDeveloperTools/SLUtilities'
      sf.dependency 'Masonry'
      sf.dependency 'SDAutoLayout'
      sf.dependency 'YYCategories'
      sf.dependency 'AFNetworking'
#      sf.dependency 'MMKV'
      sf.dependency 'Nama-lite', '~> 8.2.0'
      sf.dependency 'THSDKCode'
      sf.frameworks = 'UIKit', 'Foundation', 'AVFoundation', 'CoreMotion', 'QuartzCore'
  end
  s.subspec "SLBaseClass" do |baseClass|
    baseClass.source_files = 'SLDeveloperTools/SLBaseClass/*.{h,m}'
    baseClass.public_header_files = 'SLDeveloperTools/SLBaseClass/*.h'
    baseClass.dependency "SLDeveloperTools/SLCategory"
    baseClass.dependency "SLDeveloperTools/SLMacro"
    baseClass.dependency 'SDWebImage', '= 5.10.0'
    baseClass.dependency 'YYWebImage', '~> 1.0.5'
    baseClass.dependency 'AFNetworking'
    baseClass.frameworks = 'UIKit', 'Foundation'
  end

  s.subspec 'UGC_Upload' do |ugc|
    ugc.source_files = 'SLDeveloperTools/UGC_Upload/*.{h,m}','SLDeveloperTools/UGC_Upload/include/*.h'
    ugc.vendored_frameworks = 'SLDeveloperTools/UGC_Upload/COSSDK/QCloudCore.framework', 'SLDeveloperTools/UGC_Upload/COSSDK/QCloudCOSXML.framework'
  end

#  图片预览组件
  s.subspec 'HZPhotoBrowser' do |hz|
    hz.source_files = 'SLDeveloperTools/HZPhotoBrowser/**/*.{h,m}'
    hz.dependency 'FLAnimatedImage'
    hz.dependency 'HXPhotoPicker', '= 3.1.6'
    hz.dependency 'Masonry'
    hz.dependency 'SDWebImage', '= 5.10.0'
    hz.dependency 'FDFullscreenPopGesture', '1.1'
    hz.dependency 'SDAutoLayout'
    hz.dependency 'DZNEmptyDataSet'
  end

  s.subspec 'SDPhotoBrowser' do |pb|
    pb.source_files = 'SLDeveloperTools/SDPhotoBrowser/*.{h,m}'
  end

#  添加话题组件
  s.subspec 'SLAddTopicTools' do |tt|
    tt.source_files = 'SLDeveloperTools/SLAddTopicTools/*.{h,m}'
    tt.dependency 'YYCategories'
    tt.dependency 'Masonry'
    tt.dependency 'SDWebImage', '= 5.10.0'
    tt.dependency 'FDFullscreenPopGesture', '1.1'
    tt.dependency 'SDAutoLayout'
    tt.dependency 'DZNEmptyDataSet'
  end
#  at好友组件
  s.subspec 'SLAtFriendsTools' do |at|
    at.source_files = 'SLDeveloperTools/SLAtFriendsTools/*.{h,m}'
    at.dependency 'ZFPlayer', '4.0.3'
    at.dependency 'ZFPlayer/ControlView', '~> 4.0.3'
    at.dependency 'ZFPlayer/AVPlayer', '~> 4.0.3'
    at.dependency 'YYCategories'
    at.dependency 'Masonry'
    at.dependency 'SDWebImage', '= 5.10.0'
    at.dependency 'FDFullscreenPopGesture', '1.1'
    at.dependency 'SDAutoLayout'
    at.dependency 'DZNEmptyDataSet'
  end
#  位置搜索组件
  s.subspec 'SLLocationSearchTools' do |ls|
    ls.source_files = 'SLDeveloperTools/SLLocationSearchTools/*.{h,m}'
    ls.dependency 'AMap2DMap-NO-IDFA'
    ls.dependency 'AMapSearch-NO-IDFA'
    ls.dependency 'Masonry'
    ls.dependency 'SDWebImage', '= 5.10.0'
    ls.dependency 'FDFullscreenPopGesture', '1.1'
    ls.dependency 'SDAutoLayout'
    ls.dependency 'DZNEmptyDataSet'
  end

#  选择音乐
 s.subspec 'SLMusicTools' do |mt|
   mt.source_files = 'SLDeveloperTools/SLMusicTools/**/*.{h,m}'
   mt.dependency 'YYWebImage'
   mt.dependency 'SDAutoLayout'
   mt.dependency 'lottie-ios', '2.5.3'
   mt.dependency 'Masonry'
   mt.dependency 'SDWebImage', '= 5.10.0'
   mt.dependency 'FDFullscreenPopGesture', '1.1'
   mt.dependency 'SDAutoLayout'
   mt.dependency 'DZNEmptyDataSet'
 end
  s.subspec "SLAppInfo" do |appInfo|
    appInfo.source_files = 'SLDeveloperTools/SLAppInfo/*.{h,m,mm,hpp,cpp}'
    appInfo.public_header_files = 'SLDeveloperTools/SLAppInfo/*.h'
    appInfo.dependency 'SLDeveloperTools/SLBaseClass'
    appInfo.dependency 'SLDeveloperTools/SLCategory'
    appInfo.dependency 'SLDeveloperTools/SLWidget/SLBaseEmptyVC'
    appInfo.dependency 'SLDeveloperTools/SLWidget/SLShareTools'
    appInfo.dependency 'SLDeveloperTools/SLMacro'
    appInfo.dependency 'SLDeveloperTools/SLUtilities'
    appInfo.dependency 'SLDeveloperTools/SLNetTools'
    appInfo.dependency 'SLDeveloperTools/SLMaskTools'
    appInfo.dependency 'SLDeveloperTools/SLVideoWaterMaskTools'
    appInfo.dependency 'MJExtension'
#    appInfo.dependency 'MMKV'
    appInfo.dependency 'UMPush',  '3.3.1'
    appInfo.dependency 'UMShare/UI', '6.10.4'
    appInfo.dependency 'UMShare/Social/WeChat'
    appInfo.dependency 'UMShare/Social/QQ'
    appInfo.dependency 'YYText'
    appInfo.dependency 'YYCategories'
    appInfo.dependency 'RealReachability'
    appInfo.dependency 'Bugly', '~> 2.5.90'
    appInfo.dependency 'Qiniu', '= 8.3.1'
    appInfo.dependency 'SLAlipaySDK_NO_UTDID'
    appInfo.dependency 'SLWechatOpenSDK'
    appInfo.dependency 'HPGrowingTextView'
    appInfo.dependency 'SocketRocket'
    appInfo.dependency 'STPopup'
    appInfo.dependency 'FLAnimatedImage'
    appInfo.dependency 'SobotKit', '3.0.2'
    appInfo.dependency 'JXPagingView/Pager'
    appInfo.dependency 'SDWebImage', '5.10.0'
    appInfo.dependency 'ZFPlayer', '4.0.3'
    appInfo.dependency 'ZFPlayer/ControlView', '4.0.3'
    appInfo.dependency 'ZFPlayer/AVPlayer', '4.0.3'
    appInfo.dependency 'TXLiteAVSDK_Professional'
    appInfo.dependency 'NIMKit/Full'
    appInfo.dependency 'FMDB'
    appInfo.dependency 'WebViewJavascriptBridge', '~> 6.0'
    appInfo.dependency 'SLBaiChuanSDK'
    appInfo.dependency 'IAPHelper'
    appInfo.dependency 'DTCoreText'
    appInfo.dependency 'SSZipArchive'
    appInfo.dependency 'IQKeyboardManager'
    
    
    appInfo.frameworks = 'UIKit', 'Foundation', 'SystemConfiguration', 'CoreTelephony', 'Photos'
    appInfo.weak_frameworks    = "UserNotifications"
    appInfo.vendored_libraries = 'SLDeveloperTools/SLAppInfo/libmp3lame.a'
    appInfo.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    appInfo.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  end


  s.subspec 'SLLiveTools' do |live|
    live.source_files = 'SLDeveloperTools/SLLive/**/*.{h,m}'
    live.dependency 'Masonry'
    live.dependency 'SDAutoLayout'
  end
  
  

  s.resource     = 'SLDeveloperTools/SLDeveloperTools.bundle','SLDeveloperTools/Resources/MP3/*','SLDeveloperTools/Resources/PlaceholderIcon/*','SLDeveloperTools/Resources/skin/*'

  # s.public_header_files = 'Pod/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

end
