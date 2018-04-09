#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

/** A photo filter based on Photoshop filter Moonlight
 */

// Note: If you want to use this effect you have to add LUT_Moonlight.png
//       from Resources folder to your application bundle.

@interface GPUImageMoonlightFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
