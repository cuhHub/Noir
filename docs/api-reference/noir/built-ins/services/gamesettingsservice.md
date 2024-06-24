# GameSettingsService

**Noir.Services.GameSettingsService**: `NoirService`

A service for changing and accessing the game's settings.

***

```lua
Noir.Services.GameSettingsService:GetSettings()
```

Returns a list of all game settings.

#### Returns

* `SWGameSettings`

***

```lua
Noir.Services.GameSettingsService:GetSetting(name)
```

Returns the value of the provided game setting.

#### Parameters

* `name`: SWGameSettingEnum

#### Returns

* `any`

***

```lua
Noir.Services.GameSettingsService:SetSetting(name, value)
```

Sets the value of the provided game setting.

#### Parameters

* `name`: SWGameSettingEnum
* `value`: any
