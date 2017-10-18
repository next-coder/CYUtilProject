//
//  CYShareModel.m
//  CYUtilProject
//
//  Created by xn011644 on 13/10/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYShareModel.h"

@implementation CYShareModel

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
                    thumbnail:(NSData *)thumbnail
                          url:(NSString *)url
                         data:(NSData *)data
                         type:(XNShareContenType)type {
    if (self = [super init]) {

        _title = title;
        _content = content;
        _thumbnail = thumbnail;
        _url = url;
        _data = data;
        _type = type;
    }
    return self;
}

- (BOOL)isValid {
    switch (_type) {
        case XNShareContenTypeText:
            return self.content != nil;
            break;

        case XNShareContenTypeURL:
            return self.url != nil;
            break;

        case XNShareContenTypeImage:
            return (self.url != nil || self.data != nil);
            break;
    }
}

+ (instancetype)textModelWithContent:(NSString *)content {
    return [[CYShareModel alloc] initWithTitle:nil content:content
                                     thumbnail:nil
                                           url:nil
                                          data:nil
                                          type:XNShareContenTypeText];
}

+ (instancetype)urlModelWithTitle:(NSString *)title
                          content:(NSString *)content
                        thumbnail:(NSData *)thumbnail
                              url:(NSString *)url {

    return [[CYShareModel alloc] initWithTitle:title
                                       content:content
                                     thumbnail:thumbnail
                                           url:url
                                          data:nil
                                          type:XNShareContenTypeURL];
}

+ (instancetype)imageModelWithTitle:(NSString *)title
                            content:(NSString *)content
                          thumbnail:(NSData *)thumbnail
                                url:(NSString *)url {

    return [[CYShareModel alloc] initWithTitle:title
                                       content:content
                                     thumbnail:thumbnail
                                           url:url
                                          data:nil
                                          type:XNShareContenTypeImage];
}

+ (instancetype)imageModelWithTitle:(NSString *)title
                            content:(NSString *)content
                          thumbnail:(NSData *)thumbnail
                               data:(NSData *)data {

    return [[CYShareModel alloc] initWithTitle:title
                                       content:content
                                     thumbnail:thumbnail
                                           url:nil
                                          data:data
                                          type:XNShareContenTypeImage];

}

@end
