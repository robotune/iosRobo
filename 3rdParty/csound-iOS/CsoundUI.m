/*
 
 CsoundUI.m:
 
 Copyright (C) 2014 Steven Yi, Victor Lazzarini, Aurelius Prochazka
 
 This file is part of Csound iOS Examples.
 
 The Csound for iOS Library is free software; you can redistribute it
 and/or modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 Csound is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with Csound; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 02111-1307 USA
 
 */

#import "CsoundUI.h"


#import "OutputBinding.h"
#import "InputBinding.h"

@interface CsoundUI () {
    CsoundObj *csoundObj;
}
@end

@implementation CsoundUI

- (instancetype)initWithCsoundObj:(CsoundObj *)csound {
    self = [super init];
    if (self) {
        csoundObj = csound;
    }
    return self;
}

- (void)addOutputBinding:(NSString *)channelName withDefaultValue:(float)value
{
    OutputBinding *baseCsoundBinding;
    baseCsoundBinding = [[OutputBinding alloc] initWithValue:channelName
                         
                                            withDefaultValue:value];
    [csoundObj addBinding:baseCsoundBinding];
}

- (void)addInputBinding:(InputBinding *)binding
{
    [csoundObj addBinding:binding];
}





@end
