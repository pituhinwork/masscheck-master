
@class RadiosPreferencesDelegate;

@interface RadiosPreferences : NSObject  {
    struct __SCPreferences { } *_prefs;
    int _applySkipCount;
    RadiosPreferencesDelegate *_delegate;
    BOOL _isCachedAirplaneModeValid;
    BOOL _cachedAirplaneMode;
    BOOL notifyForExternalChangeOnly;
}

@property (nonatomic, strong) BOOL airplaneMode;
@property (nonatomic, strong) BOOL notifyForExternalChangeOnly;
//@property (nonatomic, strong) RadiosPreferencesDelegate *delegate;


- (void)setAirplaneMode:(BOOL)arg1;
- (id)init;
- (void)setValue:(void*)arg1 forKey:(id)arg2;
- (void)dealloc;
- (void)synchronize;
- (void)setDelegate:(id)arg1;
- (id)delegate;
- (BOOL)airplaneMode;
- (void*)getValueForKey:(id)arg1;
- (void)refresh;
- (void)initializeSCPrefs:(id)arg1;
- (void)notifyTarget:(unsigned int)arg1;
- (void)setCallback:(int (*)())arg1 withContext:(struct { int x1; void *x2; int (*x3)(); int (*x4)(); int (*x5)(); }*)arg2;
- (void)setNotifyForExternalChangeOnly:(BOOL)arg1;
- (BOOL)notifyForExternalChangeOnly;

@end
