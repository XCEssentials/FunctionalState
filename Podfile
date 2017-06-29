repoName = 'FunctionalState'
projName = 'Main'

#===

platform :ios, '8.0'

workspace repoName

use_frameworks!

#===

def sharedPods

	pod 'XCEStaticState', :path => './../StaticState' #, '~> 1.2'

end

#===

target 'Fwk' do

	project projName

	#===

	sharedPods

end

target 'Tests' do

	project projName
    
    #===

	sharedPods

    #===
    
    pod 'XCETesting', '~> 1.1'

end
