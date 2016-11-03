Pod::Spec.new do |s|
  s.name         = 'libksygpulive'
  s.version      = '1.8.6'
  s.license      = {
:type => 'Proprietary',
:text => <<-LICENSE
      Copyright 2015 kingsoft Ltd. All rights reserved.
      LICENSE
  }
  s.homepage     = 'http://v.ksyun.com/doc.html'
  s.authors      = { 'ksyun' => 'zengfanping@kingsoft.com' }
  s.summary      = 'libksylive help you play and stream live video from ios mobile devices.'
  s.description  = <<-DESC
    * KSYMediaPlayer lite/vod manages the playback of movie or live streaming
    * libksygpulive  lite/265 capture video, compress and publish stream to rtmp server
  DESC
  s.platform     = :ios, '7.0'
  s.ios.library = 'z', 'iconv', 'stdc++.6', 'bz2'
  s.ios.frameworks   = [ 'AVFoundation', 'VideoToolbox']
  s.ios.deployment_target = '7.0'
  s.source = { 
    :git => 'https://github.com/ksvc/KSYLive_iOS.git',
    :tag => 'v'+s.version.to_s
  }
  s.requires_arc = true
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC -all_load' }

  # Exclude optional Search and Testing modules
  s.default_subspec = 'libksygpulive'

  # Internal dependency 
  subLibs = [ 'base','yuv','mediacodec',
              'mediacore_dec_lite',
              'mediacore_dec_vod',
              'mediacore_enc_lite',
              'mediacore_enc_265']
  subLibs.each do |subName|
    s.subspec subName do |sub|
      sub.vendored_library = 'prebuilt/libs/libksy%s.a' % subName
    end
  end
  s.subspec 'player' do |sub|
    sub.source_files =  'prebuilt/include/KSYPlayer/*.h'
    sub.vendored_library = 'prebuilt/libs/libksyplayer.a'
  end
  s.subspec 'streamer' do |sub|
    sub.source_files =  'prebuilt/include/KSYStreamer/*.h'
    sub.vendored_library = 'prebuilt/libs/libksystreamer.a'
  end

  # lite version of KSYMediaPlayer (less decoders)
  s.subspec 'KSYMediaPlayer' do |sub|
    sub.source_files =  'prebuilt/include/KSYPlayer/*.h'
    sub.dependency 'libksygpulive/base'
    sub.dependency 'libksygpulive/mediacore_dec_lite'
    sub.dependency 'libksygpulive/player'
  end
  # vod version of KSYMediaPlayer (more decoders)
  s.subspec 'KSYMediaPlayer_vod' do |sub|
    sub.source_files =  'prebuilt/include/KSYPlayer/*.h'
    sub.dependency 'libksygpulive/base'
    sub.dependency 'libksygpulive/mediacore_dec_vod'
    sub.dependency 'libksygpulive/player'
  end
  s.subspec 'libksygpulive' do |sub|
    sub.source_files =  ['prebuilt/include/**/*.h',
                         'source/*.{h,m}']
    sub.dependency 'GPUImage'
    sub.dependency 'libksygpulive/base'
    sub.dependency 'libksygpulive/player'
    sub.dependency 'libksygpulive/yuv'
    sub.dependency 'libksygpulive/mediacodec'
    sub.dependency 'libksygpulive/mediacore_enc_lite'
    sub.dependency 'libksygpulive/streamer'
  end
  s.subspec 'libksygpulive_265' do |sub|
    sub.source_files =  ['prebuilt/include/**/*.h',
                         'source/*.{h,m}']
    sub.dependency 'GPUImage'
    sub.dependency 'libksygpulive/base'
    sub.dependency 'libksygpulive/player'
    sub.dependency 'libksygpulive/yuv'
    sub.dependency 'libksygpulive/mediacodec'
    sub.dependency 'libksygpulive/mediacore_enc_265'
    sub.dependency 'libksygpulive/streamer'
  end
  s.subspec 'KSYGPUResource' do |sub|
    sub.resource = 'resource/KSYGPUResource.bundle'
  end
end
