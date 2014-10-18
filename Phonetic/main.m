//
//  main.m
//  Phonetic
//
//  Created by Kam on 10/18/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

static NSString *phonitcFirstLetters(NSString *sourceString) {
    NSMutableString *phoneticFirstLetters = [NSMutableString string];
    for (int i = 0; i < sourceString.length; i++) {
        NSString *c = [sourceString substringWithRange:NSMakeRange(i, 1)];
        
        NSMutableString *source = [c mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
        
        
        [phoneticFirstLetters appendString:[source substringWithRange:NSMakeRange(0, 1)]];
    }
    return phoneticFirstLetters;
}

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        ABAddressBook *addressBook = [ABAddressBook addressBook];
        
        for (ABPerson *person in addressBook.people) {
            
//            [person setValue:nil forProperty:kABFirstNamePhoneticProperty];
//            [person setValue:nil forProperty:kABLastNamePhoneticProperty];
            
            NSString *firstName = [person valueForProperty:kABFirstNameProperty];
            NSString *lastName = [person valueForProperty:kABLastNameProperty];
            NSString *company = [person valueForProperty:kABOrganizationProperty];
            
            
            NSMutableString *phonetic = [NSMutableString string];
            
            if (firstName || lastName) {
                if (lastName) {
                    [phonetic appendString:phonitcFirstLetters(lastName)];
                }
                
                if (firstName) {
                    [phonetic appendString:phonitcFirstLetters(firstName)];
                }
            } else {
                if (company) {
                    [phonetic appendString:phonitcFirstLetters(company)];
                }
            }
            
            [person setValue:phonetic forProperty:kABLastNamePhoneticProperty];
        }
        [addressBook save];
        
    }
    return 0;
}