projName = 'State'
projSummary = 'Turn any object into a discrete system and describe its states in a declarative style.'
companyPrefix = 'XCE'
companyName = 'XCEssentials'
companyGitHubAccount = 'https://github.com/' + companyName
companyGitHubPage = 'https://' + companyName + '.github.io'

#===

Pod::Spec.new do |s|

  s.name                      = companyPrefix + projName
  s.summary                   = projSummary
  s.version                   = '2.6.0'
  s.homepage                  = companyGitHubPage + '/' + projName
  
  s.source                    = { :git => companyGitHubAccount + '/' + projName + '.git', :tag => s.version }
  s.source_files              = 'Src/**/*.swift'

  s.ios.deployment_target     = '8.0'
  s.requires_arc              = true
  
  s.dependency                'XCEStaticState', '~> 1.1'

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  s.deprecated                = true
  s.deprecated_in_favor_of    = 'XCEFunctionalState'
  
end
