local bullet = table.Copy(ACT3.BulletBase)

bullet.Name = "pzf3_he" -- the bullet's code name
bullet.PrintName = "PZF3 HE" -- the displayed bullet name
bullet.Type = "HE"

bullet.Description = ACT3.Descriptions.HE -- {"line1", "line2"...}

bullet.Calibre = "pzf3" -- determines what types of magazines this bullet can fit in

bullet.CaseEffect = "" -- the visual shell ejection effect of the bullet

bullet.Num = 1 -- how many bullets are fired

bullet.Projectile = "proj_pzf3_he" -- name of projectile entity
bullet.ProjectileForce = 50000 -- force at which projectile will be fired
bullet.ProjectileAngles = Angle(0, 0, 0) -- angle offset of projectile

bullet.GiveCount = 2

ACT3_LoadBullet(bullet)