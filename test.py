#Fiberstrno1:100x100x100
#Watershedno6: 70x70x70
#Fiber_str.les: 400x400x400 required

from mayavi import mlab
import numpy as np
import itertools as iter

pore_x=[]
pore_y=[]
pore_z=[]






f = open('pore.dat')
## Read the first line 
line = f.readline()



'''
c=0
for i in range(0,len(line)):
	if(line[i]!=' ' and line[i]!='\n'):
		c+=1

print c

print len(line)
if (line[20]=='\n'):
	print "hello"
#print type(line[0])

'''
c_y=0
c_x=0
c_z=0

rock_x=[]
rock_y=[]
rock_z=[]

Len=96


while line:
	c_z=0
	if (c_y==Len):
		c_y=0
		c_x+=1
	l=map(int,line.split())

	for i in range(0,len(l)):
		if l[i]!=0:
			pore_z.append(c_z)
			pore_y.append(c_y)
			pore_x.append(c_x)
			c_z+=1

		else:
			rock_z.append(c_z)
			rock_x.append(c_x)
			rock_y.append(c_y)
			c_z+=1	
	
	
			

	line = f.readline()
	c_y+=1

	
f.close()

#print rock_x,'\n',rock_y,'\n',rock_z




print len(rock_x)+len(pore_x),' ',len(rock_y)+len(pore_y),' ',len(rock_z)+len(pore_z)

x=np.array(pore_x)
y=np.array(pore_y)
z=np.array(pore_z)

zipped=zip(x,y,z)

np.savetxt('fibmb96.dat',zipped,fmt='%i %i %i')

#print rock_z
print "Length of lattice=", Len

pts=mlab.points3d(x,y,z,color=(1.0,0.0,0.0),mode='cube',scale_factor=1)
mlab.show()


