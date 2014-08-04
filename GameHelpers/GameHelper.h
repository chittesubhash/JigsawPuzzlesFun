

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameHelper : NSObject {
    
}
+ (NSMutableDictionary *) getPlist:(NSString*)plist;
+ (float)randomBetween:(float)smallNumber and:(float)bigNumber;
+ (BOOL) isRetinaIpad;
+ (BOOL) isRetinaIphone;
+ (NSString *)generateUUID;
+ (CCMenuItemSprite *) createMenuItemBySprite:(NSString *)name target:(id)target selector:(SEL)selector;
+ (CCLabelBMFont*) getLabelFontByLanguage:(NSArray*)labels andLanguage:(int)languageID;
+ (NSString*)getResourcePathByName:(NSString*)fileName;
+ (NSString*)getSystemLanguage;
@end
