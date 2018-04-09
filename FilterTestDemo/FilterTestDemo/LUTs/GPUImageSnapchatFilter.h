#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

/** A photo filter based on Photoshop filter Snap
 */

// Note: If you want to use this effect you have to add LUT_Snap.png
//       from Resources folder to your application bundle.

@interface GPUImageSnapchatFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
