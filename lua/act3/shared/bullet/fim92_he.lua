local bullet = table.Copy(ACT3.BulletBase)

bullet.Name = "fim92_he" -- the bullet's code name
bullet.PrintName = "FIM-92 AA HE" -- the displayed bullet name
bullet.Type = "AA"

bullet.Description = {"AA Heat Seeking rocket", "Fire-and-Forgot, 20 degrees seeking angle head"}

bullet.Calibre = "fim92" -- determines what types of magazines this bullet can fit in

bullet.CaseEffect = "" -- the visual shell ejection effect of the bullet

bullet.Num = 1 -- how many bullets are fired

bullet.Projectile = "proj_fim92" -- name of projectile entity
bullet.ProjectileForce = 50000 -- force at which projectile will be fired
bullet.ProjectileAngles = Angle(0, 0, 0) -- angle offset of projectile

bullet.GiveCount = 2

ACT3_LoadBullet(bullet)