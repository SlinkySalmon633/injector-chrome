script.Name="I Like Trains"local a=Instance.new("Frame")a.ZIndex=21;local b=Instance.new("TextLabel")local c=Instance.new("TextButton")local
d=Instance.new("TextButton")local e=Instance.new("TextButton")local f=Instance.new("TextButton")local g=Instance.new("TextButton")local
h=Instance.new("TextButton")local i=Instance.new("TextButton")local j=Instance.new("TextButton")local k=Instance.new("TextButton")local
l=Instance.new('Folder',game)local m=Instance.new("TextButton")local n=false;for o,p in pairs(game.CoreGui.RobloxGui:GetChildren())do
a.Parent=p;break
end;a.BackgroundColor3=Color3.fromRGB(0,0,0)a.BackgroundTransparency=0.500;a.BorderColor3=Color3.fromRGB(107,169,211)a.BorderSizePixel=3;a.Position=UDim2.new(0.0339384377,0,0.0859950855,0)a.Size=UDim2.new(0,183,0,283)a.Active=true;a.Draggable=true;b.Name="Nigger.mp4"b.Parent=a;b.BackgroundColor3=Color3.fromRGB(255,255,255)b.BackgroundTransparency=1.000;b.Size=UDim2.new(0,183,0,31)b.Font=Enum.Font.SourceSans;b.Text="Zenon
#FreeTheFreeCheats"b.TextColor3=Color3.fromRGB(244,244,244)b.TextScaled=true;b.TextSize=14.000;b.TextWrapped=true;c.Name="A"c.Parent=a;c.BackgroundColor3=Color3.fromRGB(255,255,255)c.BackgroundTransparency=1.000;c.Position=UDim2.new(0,0,0.166077733,0)c.Size=UDim2.new(0,183,0,24)c.Font=Enum.Font.SourceSans;c.Text="Aimbot"c.TextColor3=Color3.fromRGB(255,255,255)c.TextSize=14.000;c.MouseButton1Down:Connect(function()local
q='mouse'local self={Smoothness=.5,ShowFov=true,Fov=5,TeamCheck=true}local r=game:GetService('Players')local
s=game:GetService("UserInputService")local t=r.LocalPlayer;local u=t:GetMouse()local n=false;local cam=workspace.CurrentCamera;local
v=Drawing.new("Circle")v.Position=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)v.Radius=100;v.Color=Color3.new(1,1,1)v.Thickness=2.5;v.Filled=false;v.Transparency=1;v.NumSides=15;v.Visible=self.ShowFov;function
UpdatefovSize(w)v.Radius=w*23;self.Fov=w end;UpdatefovSize(self.Fov)function GetNearest()for x,y in next,r:GetPlayers()do if
y.Character:FindFirstChild("Head")~=nil then if self.TeamCheck==true and y.TeamColor~=t.TeamColor then local
z=cam:WorldToScreenPoint(y.Character["Head"].Position)local A=(Vector2.new(u.X,u.Y)-Vector2.new(z.X,z.Y)).magnitude;if z.Z>0 and
A<=cam.ViewportSize.X/(90/self.Fov)then return y.Character end elseif self.TeamCheck~=true then local
z=cam:WorldToScreenPoint(y.Character["Head"].Position)local A=(Vector2.new(u.X,u.Y)-Vector2.new(z.X,z.Y)).magnitude;if z.Z>0 and
A<=cam.ViewportSize.X/(90/self.Fov)then return y.Character end end end end end;u.Button2Down:Connect(function()n=true
end)u.Button2Up:Connect(function()n=false end)s.InputBegan:Connect(function(B)if B.KeyCode==Enum.KeyCode.J then self.TeamCheck=not 
self.TeamCheck end end)s.InputBegan:Connect(function(B)if B.KeyCode==Enum.KeyCode.F1 then UpdatefovSize(self.Fov+0.5)end
end)s.InputBegan:Connect(function(B)if B.KeyCode==Enum.KeyCode.F2 then UpdatefovSize(self.Fov-0.5)end end)while wait()do
end)s.InputBegan:Connect(function(B)if B.KeyCode==Enum.KeyCode.F2 then UpdatefovSize(self.Fov-0.5)end end)while wait()do
D=Vector2.new((C.X-u.X)*self.Smoothness,(C.Y-u.Y)*self.Smoothness)mousemoverel(D.X,D.Y)end end)end
end)d.Name="NR"d.Parent=a;d.BackgroundColor3=Color3.fromRGB(255,255,255)d.BackgroundTransparency=1.000;d.Position=UDim2.new(0,0,0.2508834,0)d.Size=UDim2.new(0,183,0,24)d.Font=Enum.Font.SourceSans;d.Text="No
Recoil"d.TextColor3=Color3.fromRGB(255,255,255)d.TextSize=14.000;d.MouseButton1Down:Connect(function()while wait()do
pcall(function()getsenv(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.MainLocal).CameraRecoil=function()end end)end
end)e.Name="NS"e.Parent=a;e.BackgroundColor3=Color3.fromRGB(255,255,255)e.BackgroundTransparency=1.000;e.Position=UDim2.new(0,0,0.335689068,0)e.Size=UDim2.new(0,183,0,24)e.Font=Enum.Font.SourceSans;e.Text="No
Spread"e.TextColor3=Color3.fromRGB(255,255,255)e.TextSize=14.000;e.MouseButton1Down:Connect(function()require(game:GetService("ReplicatedStorage").GlobalStuff).ConeOfFire=function(...)return({...})
[3]end
end)f.Name="SA"f.Parent=a;f.BackgroundColor3=Color3.fromRGB(255,255,255)f.BackgroundTransparency=1.000;f.Position=UDim2.new(0,0,0.420494735,0)f.Size=UDim2.new(0,183,0,24)f.Font=Enum.Font.SourceSans;f.Text="Silent
Aim"f.TextColor3=Color3.fromRGB(255,255,255)f.TextSize=14.000;f.MouseButton1Down:Connect(function()local E;local
v=Drawing.new("Circle")cam=workspace.CurrentCamera;v.Position=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)v.Radius=100;v.Color=Color3.new(1,1,1)v.Thickness=2.5;v.Filled=false;v.Transparency=1;v.NumSides=15;v.Visible=true;function
UpdatefovSize(w)v.Radius=w*23;E=w end;UpdatefovSize(4.5)local F=game:GetService("Players").LocalPlayer;local u=F:GetMouse()local
G=false;local H=game:GetService('UserInputService')local I=game:GetService('RunService')local J=game:GetService('Players')local
K=game:GetService('StarterGui')local L=J.LocalPlayer;local M=I:IsStudio()local N=game.CoreGui;local O=L:GetMouse()local P=O.Icon;local
Q=workspace.CurrentCamera;targetpart="Head"local function getClosestPlayer()lowest=math.huge;pcall(function()for x,y in next,J:GetPlayers()do
if y.Name~=L.Name and y.Character~=nil and y.Character:FindFirstChild(targetpart)then local
z=Q:WorldToScreenPoint(y.Character[targetpart].Position)local A=(Vector2.new(O.X,O.Y)-Vector2.new(z.X,z.Y)).magnitude;if z.Z>0 and
A<=Q.ViewportSize.X/(90/E)and A<lowest then lowest=A;closestPlayer=y end end end end)return closestPlayer
end;game:GetService("UserInputService").InputBegan:Connect(function(R,S)if not S and R.KeyCode==Enum.KeyCode.H then G=not G end end)local
T=getrawmetatable(game)local U=T.__index;local V=T.__namecall;if setreadonly then setreadonly(T,false)else make_writeable(T,true)end;local
W=getnamecallmethod or get_namecall_method;local X=newcclosure or function(Y)return Y end;T.__index=X(function(Z,_)if Z==u and
tostring(_)=="Hit"then if getClosestPlayer()~=nil and getClosestPlayer().Character and
getClosestPlayer().Character:FindFirstChild("Head")then return getClosestPlayer().Character.LowerTorso.CFrame end end;return
U(Z,_)end)end)g.Name="W"g.Parent=a;g.BackgroundColor3=Color3.fromRGB(255,255,255)g.BackgroundTransparency=1.000;g.Position=UDim2.new(0,0,0.505300403,0)g.Size=UDim2.new(0,183,0,24)g.Font=Enum.Font.SourceSans;g.Text="Wallbang"g.TextColor3=Color3.fromRGB(255,255,255)g.TextSize=14.000;g.MouseButton1Down:Connect(function()local
F=game:GetService("Players").LocalPlayer;local u=F:GetMouse()local G=false;local H=game:GetService('UserInputService')local
I=game:GetService('RunService')local J=game:GetService('Players')local K=game:GetService('StarterGui')local L=J.LocalPlayer;local
M=I:IsStudio()local N=game.CoreGui;local O=L:GetMouse()local P=O.Icon;local Q=workspace.CurrentCamera;targetpart="Head"local
T=getrawmetatable(game)local U=T.__index;local V=T.__namecall;if setreadonly then setreadonly(T,false)else make_writeable(T,true)end;local
W=getnamecallmethod or get_namecall_method;local X=newcclosure or function(Y)return Y end;T.__namecall=X(function(...)local a0=W()local a1=
{...}if tostring(a0)=="FindPartOnRayWithIgnoreList"and getClosestPlayer()and getClosestPlayer().Character then return V(a1[1],a1[2],
{game:GetService("Workspace").IgnoreThese,game:GetService("Players").LocalPlayer.Character,game:GetService("Workspace").BuildStuff,game:GetService("Workspace").Map})end;return
V(...)end)if setreadonly then setreadonly(T,true)else make_writeable(T,false)end;local
a2;a2=hookfunction(workspace.FindPartOnRayWithIgnoreList,function(...)local a1={...}a1[3]=
{game:GetService("Workspace").IgnoreThese,game:GetService("Players").LocalPlayer.Character,game:GetService("Workspace").BuildStuff,game:GetService("Workspace").Map}return
a2(unpack(a1))end)end)h.Name="RM"h.Parent=a;h.BackgroundColor3=Color3.fromRGB(255,255,255)h.BackgroundTransparency=1.000;h.Position=UDim2.new(0,0,0.59010607,0)h.Size=UDim2.new(0,183,0,24)h.Font=Enum.Font.SourceSans;h.Text="Remove
Map"h.TextColor3=Color3.fromRGB(255,255,255)h.TextSize=14.000;h.MouseButton1Down:Connect(function()local
a3=Instance.new('Folder',l)a3.Name='map'workspace.BuildStuff.Name="Lobb"workspace.Lobby.Name="BuildStuff"workspace.Lobb.Name="Lobby"while
wait()do for o,a4 in pairs(game:GetService("Workspace").Lobby:GetChildren())do a4.Parent=a3 end end
end)i.Name="RFAFR"i.Parent=a;i.BackgroundColor3=Color3.fromRGB(255,255,255)i.BackgroundTransparency=1.000;i.Position=UDim2.new(0,0,0.671378136,0)i.Size=UDim2.new(0,183,0,24)i.Font=Enum.Font.SourceSans;i.Text="Rapid
Fire And Fast
Reload"i.TextColor3=Color3.fromRGB(255,255,255)i.TextSize=14.000;i.MouseButton1Down:Connect(function()hookfunction(wait,function()return
game:GetService("RunService").Stepped:Wait()end)end)j.Name="HE"j.Parent=a;j.BackgroundColor3=Color3.fromRGB(255,255,255)j.BackgroundTransparency=1.000;j.Position=UDim2.new(0,0,0.745,0)j.Size=UDim2.new(0,183,0,24)j.Font=Enum.Font.SourceSans;j.Text="No
a5=T.__namecall;local setreadonly=setreadonly or make_writable;setreadonly(T,false)T.__namecall=function(self,...)local a1={...}local
a0=getnamecallmethod()if a0=="FireServer"and a1[1]==8 then return end;return
a5(self,...)end;setreadonly(T,true)end)k.Name="HE1"k.Parent=a;k.BackgroundColor3=Color3.fromRGB(255,255,255)k.BackgroundTransparency=1.000;k.Position=UDim2.new(0,0,0.745+0.0737,0)k.Size=UDim2.new(0,183,0,24)k.Font=Enum.Font.SourceSans;k.Text="Crack
All Glass"k.TextColor3=Color3.fromRGB(255,255,255)k.TextSize=14.000;k.MouseButton1Down:Connect(function()for o,p in
pairs(game.Workspace:GetDescendants())do if p.Name=="Glass"then require(game.ReplicatedStorage.NetworkModule):FireServer("CrackGlass",p)
end
end)m.Name="HE2"m.Parent=a;m.BackgroundColor3=Color3.fromRGB(255,255,255)m.BackgroundTransparency=1.000;m.Position=UDim2.new(0,0,0.745+0.0737+0.0737,0)m.Size=UDim2.new(0,183,0,24)m.Font=Enum.Font.SourceSans;m.Text="Copy
Discord
Inv"m.TextColor3=Color3.fromRGB(255,255,255)m.TextSize=14.000;m.MouseButton1Down:Connect(function()setclipboard('https://'..'discord.gg/'..'uEwQUgz')end)
