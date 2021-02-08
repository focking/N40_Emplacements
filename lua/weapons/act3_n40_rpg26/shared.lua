SWEP.Base = "act3_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.PrintName = "RPG-26"
SWEP.Category = "Pizza Handheld"

SWEP.Desc_Country = "Russia"
SWEP.Desc_Manufacturer = "Bazalt"
SWEP.Desc_Mechanism = "Disposable anti-tank rocket launcher"
SWEP.Desc_Year = 1958

--SWEP.Purpose = "One of the most ubiquitous assault rifles ever invented. The right arm of the oppressed world; so great Mozambique put it on its flag. Rugged as a rock, and crude as one too."

SWEP.Desc_Weight = 2.9 -- kg
SWEP.ACT3Cat = ACT3_CAT_EXPLOSIVE
SWEP.Sidearm = false

SWEP.Slot = 3


 
SWEP.WorldModel = "models/rpg26/rpg26-1.mdl"
SWEP.WorldModelBase = "models/rpg26/rpg26-1.mdl" -- Worldmodel base of the weapon world model.
SWEP.WorldModelPos = Vector(1.083, 0.833, -4)
SWEP.WorldModelAng = Angle(-12, 0, 180)
SWEP.WorldModelScale = 0.85

SWEP.NewMuzzleOffset = Vector(4, 1, 14)

SWEP.ReloadSoundsTable = {
    {
        time = 1.0,
        path = "handheld/rpg26/deploy.wav",
    },
}

SWEP.TrueIronsPos = Vector(0, 9, -7.86)
SWEP.TrueIronsAng = Vector(0, 0, 0)

SWEP.LowPos = Vector(4.623, 18.693, -13.266)
SWEP.LowAng = Vector(-25.327, -11.256, 14.069)


SWEP.DamageMult = 1.0 -- the weapon's main stats are just taken from the bullet
SWEP.ShootingDelay = 60 / 600
SWEP.TriggerDelay = 0

SWEP.Recoil = 3.5
SWEP.RecoilAngles = 20

SWEP.BlowbackAmount = 3
SWEP.BlowbackRecovery = 3
SWEP.BlowbackMax = 3
SWEP.RollBlowbackAmount = 3
SWEP.RollBlowbackRecovery = 10
SWEP.RollBlowbackMax = 45

SWEP.HeatAccumulation = 35 -- Out of 100, the amount of heat each shot adds to the weapon
SWEP.HeatDissipation = 200 -- Amount of heat dissipated per second

SWEP.Precision = 1 / 500
SWEP.MaxHeatPrecision = 1 / 100
SWEP.HipfirePenalty = 0 -- Deviation applied on hip fire
SWEP.MaxHeatHipfirePenalty = 0.075
SWEP.MaxMovePenalty = 0.05
SWEP.DispersionInSights = true

SWEP.Sway = 3



SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.5


SWEP.DoesNotReload = true
SWEP.OpenBolt = true -- this weapon will not chamber a round to fire. Instead, it will take rounds directly from the magazine. Examples of such weapons include revolvers and open bolt guns.
SWEP.InternalMag = true -- whether this weapon uses detachable magazines or loads rounds directly into the weapon

SWEP.DefaultLoad = "rpg26_he" -- the round that this gun will be loaded with by default
SWEP.Magazine = {
    Type = "rpg26_chamber",
    Rounds = {}
}

SWEP.MagazineType = "int"

SWEP.Calibre = "rpg26"
SWEP.PrintCalibre = "Signle Shot RPG26"

SWEP.MuzzleEffect = "act3_muzzleeffect"
SWEP.Suppressed = false 
SWEP.SoundShoot = "handheld/rpg26/fire.wav"
SWEP.SoundShootVol = 140
SWEP.SoundShootPitch = 110

SWEP.Magnification = 1

SWEP.CannotCycle = true

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG
SWEP.AnimReload = ACT_HL2MP_GESTURE_RELOAD_AR2
SWEP.AnimMeleeAttack = ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND

SWEP.HoldtypePassive = "passive"
SWEP.HoldtypeHip = "crossbow"
SWEP.HoldtypeSights = "rpg"
SWEP.HoldtypeBipod = "rpg"

SWEP.Firemodes = {
    {
        Automatic = false,
        BurstLength = 0,
        CustomFiremode = nil,
        CustomBars = nil,
        Safe = false
    },
    {
        Automatic = false,
        BurstLength = 0,
        CustomFiremode = nil,
        CustomBars = nil,
        Safe = true
    }
}
SWEP.CustomFiremode = false
SWEP.BurstLength = 0
SWEP.Automatic = false -- use this instead of changing SWEP.Primary.Automatic
SWEP.ManualAction = false

SWEP.ManualActionDelay = 0

SWEP.AimTime = 0.25

function SWEP:PostShootRound(bulletid)
    if SERVER then 
        timer.Simple(0.2,function()

            local ply = self.Owner
            if not ply:Alive() then return end
            local trace = {}
            trace.start = ply:EyePos()
            trace.endpos = trace.start + ( ply:GetRight() * 28 )
            trace.filter = {ply}

            ply:StripWeapon(self:GetClass())

            local a = ents.Create("prop_physics")
            a:SetModel(self:GetModel())
            a:SetPos(util.TraceLine( trace ).HitPos)
            a:SetAngles(self:GetAngles())
            a:Spawn()
        end)
    end 
end