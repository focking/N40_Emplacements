AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.ProjectilePrintName = ACT3_GetBulletID("50bmg_hei")


function ENT:Initialize()
		if SERVER then
        self.ProjectileEnt = ACT3_GetBulletID("50bmg_hei")
        self.Capacity = 100
        self:SetNWString("Projectile",self.ProjectilePrintName)
		self:SetModel("models/m2/rs2_m2_ammo.mdl")
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
        self:DrawShadow( true )
        self.HP = 20
     --   self:SetAngles(self:GetAngles()+Angle(180,0,-90))
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
            phys:SetMass(20)
        end
        self:SetBodygroup(2,1)
        
        self.NextCrack = CurTime()

        self.BeginBurning = false
        self.IsBurning = false

    end

end



ENT.CoockingOff = false 




function ENT:StartBurning()
	timer.Simple(15,function()
		if IsValid(self) then 
			self.CoockingOff = false 
			self:Extinguish()
			    if self.Loop then 
        self.Loop:Stop()
    end 
    if self.flame then 
        self.flame:Remove()
    end
		end 
	end)
   -- sound.Play( "emp/ammo/burning.wav", self:GetPos(), 120, math.random(100,100), 1 )
    self:Ignite(200, 32)
    timer.Simple(3,function()
        sound.Play( "emp/ammo/explosion.wav", self:GetPos(), 120, math.random(100,100), 1 )
        ParticleEffect("frag_explosion_air", self:GetPos(), self:GetAngles() )
        util.Decal( "Scorch", self:GetPos(), self:GetPos() - self:GetUp() * 256 , self )
    
        self.CoockingOff = true
    end)
end 

function ENT:OnTakeDamage(dmginfo)
    if ( not self.m_bApplyingDamage ) then
        self.HP = self.HP - dmginfo:GetDamage() 
        if self.HP <= 0 and self.BeginBurning == false then
            self.BeginBurning = true
            sound.Play( "emp/ammo/penetration.wav", self:GetPos(), 120, math.random(100,100), 1 )
            self:StartBurning()
          -- local vPoint = self:GetPos()
          -- local effectdata = EffectData()
          -- effectdata:SetOrigin( vPoint )
          -- effectdata:SetAngles(-self:GetAngles())
          -- util.Effect( "StunstickImpact", effectdata )




          -- self.Loop = CreateSound( self, "emp/ammo/poppong_loop.wav" )
          -- self.Loop:Play()
          -- ParticleEffectAttach("thermite_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
          -- self:SetColor(Color(40,40,40,255))
          -- self.flame = ents.Create("light_dynamic")
          -- self.flame:Spawn()
          -- self.flame:Activate()
          -- self.flame:SetKeyValue("distance", 256) 
          -- self.flame:SetKeyValue("brightness", 5)
          -- self.flame:SetKeyValue("_light", "255 192 64") 
          -- self.flame:Fire("TurnOn")
          -- self.flame:SetPos(self:GetPos())
        end 
    end
end
--nebel_trail




function ENT:Burning()
    local ents = ents.FindInSphere(self:GetPos(), 114)
    for k,v in pairs(ents) do 
        if v:IsPlayer() then 
            local d = DamageInfo()
            d:SetDamage( 2 )
            d:SetAttacker( self )
            d:SetDamageType( DMG_BURN )    
            v:TakeDamageInfo( d ) 
        end 
    end 
end 

function ENT:Use(activator,caller)
    activator:PickupObject( self )
end




function ENT:Think()
    if self.CoockingOff == true then 
        self:Burning()
        if self.NextCrack <= CurTime() then 
            
            local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos())
            effectdata:SetAngles(AngleRand())

            self.NextCrack = CurTime() + math.random(0.1,1)
            sound.Play( "emp/ammo/crack_0"..math.random(1,4)..".wav", self:GetPos(), 120, math.random(100,100), 1 )

            self:SetColor(Color(self:GetColor().r - 5,self:GetColor().g - 5 ,self:GetColor().b - 5))

            bullet = {}
            bullet.Num= 1
            bullet.Src = self:GetPos()
            bullet.Dir = Angle(0,0,90)
            bullet.Spread=Vector(math.random(0,5),math.random(0,5),0)
            bullet.TracerName = "tracer_green"  
            bullet.Tracer = 1
            bullet.Force = 1
            bullet.Damage = 3
            bullet.IgnoreEntity  = self
            self:FireBullets(bullet)        

            local light = ents.Create("light_dynamic")
            light:Spawn()
            light:Activate()
            light:SetKeyValue("distance", 256) 
            light:SetKeyValue("brightness", 5)
            light:SetKeyValue("_light", "255 192 64") 
            light:Fire("TurnOn")
            light:SetPos(self:GetPos())
    
            timer.Simple(0.1,function() light:Remove() end)
            local phys = self:GetPhysicsObject()
            phys:SetVelocity( Vector(math.random(-96,96),math.random(-96,96),math.random(25,96)) )

        end 
    end 
end 

function ENT:OnRemove()
    if self.Loop then 
        self.Loop:Stop()
    end 
    if self.flame then 
        self.flame:Remove()
    end
end 