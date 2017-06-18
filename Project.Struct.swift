import XCEProjectGenerator

//===

let My =
(
    repoName: "State",
    deploymentTarget: "8.0",
    companyIdentifier: "io.XCEssentials",
    companyPrefix: "XCE"
)

let BundleId =
(
    fwk: "\(My.companyIdentifier).\(My.repoName)",
    tst: "\(My.companyIdentifier).\(My.repoName).Tst"
)

//===

let specFormat = Spec.Format.v2_1_0

let project = Project("Main") { p in
    
    p.configurations.all.override(
        
        "IPHONEOS_DEPLOYMENT_TARGET" <<< My.deploymentTarget, // bug wokraround
        
        "SWIFT_VERSION" <<< "3.0",
        "VERSIONING_SYSTEM" <<< "apple-generic"
    )
    
    p.configurations.debug.override(
        
        "SWIFT_OPTIMIZATION_LEVEL" <<< "-Onone"
    )
    
    //---
    
    p.target("Fwk", .iOS, .framework) { t in
        
        t.include("Src")
        
        //---
        
        t.configurations.all.override(
            
            "PRODUCT_NAME" <<< "\(My.companyPrefix)\(My.repoName)",
            
            "IPHONEOS_DEPLOYMENT_TARGET" <<< My.deploymentTarget, // bug wokraround
            
            "PRODUCT_BUNDLE_IDENTIFIER" <<< BundleId.fwk,
            "INFOPLIST_FILE" <<< "Info/Fwk.plist",
            
            //--- iOS related:
            
            "SDKROOT" <<< "iphoneos",
            "TARGETED_DEVICE_FAMILY" <<< DeviceFamily.iOS.universal,
            
            //--- Framework related:
            
            "DEFINES_MODULE" <<< "NO",
            "SKIP_INSTALL" <<< "YES"
        )
        
        t.configurations.debug.override(
            
            "MTL_ENABLE_DEBUG_INFO" <<< true
        )
        
        //---
    
        t.unitTests { ut in
            
            ut.include("Tst")
            
            //---
            
            ut.configurations.all.override(
                
                // very important for unit tests,
                // prevents the error when unit test do not start at all
                "LD_RUNPATH_SEARCH_PATHS" <<<
                "$(inherited) @executable_path/Frameworks @loader_path/Frameworks",
                
                "IPHONEOS_DEPLOYMENT_TARGET" <<< My.deploymentTarget, // bug wokraround
                
                "PRODUCT_BUNDLE_IDENTIFIER" <<< BundleId.tst,
                "INFOPLIST_FILE" <<< "Info/Tst.plist",
                "FRAMEWORK_SEARCH_PATHS" <<< "$(inherited) $(BUILT_PRODUCTS_DIR)"
            )
            
            ut.configurations.debug.override(
                
                "MTL_ENABLE_DEBUG_INFO" <<< true
            )
        }
    }
}
