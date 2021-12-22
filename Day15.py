#!/usr/bin/env python3

#file_name = '/Users/sarah/Docs Local/aoc2021/AoC2021/Test/Day15.txt'
file_name = '/Users/sarah/Docs Local/aoc2021/AoC2021/Data/Day15.txt'

f = open(file_name, 'r')
data = f.read().splitlines()

class Point:
	def __init__(self, row, col, cost):
		self.row = row
		self.col = col
		self.cost = int(cost)
		self.pathCost = 9999999999
		self.connects = []
		
	def __str__(self):
		return f'Row: {self.row}, Col: {self.col}, Cost: {self.cost}, Path Cost: {self.pathCost}'
	
	def getID(self):
		return f'{self.row},{self.col}'
		
	def getConnects(self, pointsByLoc):
		connects = []
		left = f'{self.row},{self.col - 1}'
		right = f'{self.row},{self.col + 1}'
		above = f'{self.row - 1},{self.col}'
		below = f'{self.row + 1},{self.col}'
		if left in pointsByLoc:
			connects.append(pointsByLoc[left])
		if right in pointsByLoc:
			connects.append(pointsByLoc[right])
		if above in pointsByLoc:
			connects.append(pointsByLoc[above])
		if below in pointsByLoc:
			connects.append(pointsByLoc[below])
		return connects

	
def findPath(startPoint, unvisited):
	haveFoundEnd = False
	while True:		
		pathCost = startPoint.pathCost
		nexts = startPoint.connects
		for p in nexts:
			newPathCost = pathCost + p.cost
			if newPathCost < p.pathCost:
				p.pathCost = newPathCost
			if p.getID() == endPointId:
				return p
		unvisited.remove(startPoint)
		
		unvisited.sort(key=lambda x: x.pathCost)
		startPoint = unvisited[0]
		
		
unvisited = []
pointsByLoc = {}

startPoint = None

for rowNum in range(len(data)):
	for colNum in range(len(data[0])):
		point = Point(rowNum, colNum, data[rowNum][colNum])
		if rowNum == 0 and colNum == 0:
			point.cost = 0
			point.pathCost = 0
			startPoint = point
		unvisited.append(point)
		pointsByLoc[f'{rowNum},{colNum}'] = point
endPointId = point.getID()

for p in unvisited:
	p.connects = p.getConnects(pointsByLoc)
	
# Part 1
end = findPath(startPoint, unvisited)
print(end)


# Part 2

nums = []
for row in data:
	rowNums = [int(x) for x in row]
	nums.append(rowNums)

for row in nums:
	startNums = row
	for block in range(4):
		nextBatch = [x + 1 if x < 9 else 1 for x in startNums]
		row += nextBatch
		startNums = nextBatch
		
requiredRows = len(nums) * 5
rowIndex = 0

while len(nums) < requiredRows:
	newRow = [x + 1 if x < 9 else 1 for x in nums[rowIndex]]
	nums.append(newRow)
	rowIndex += 1
	
unvisited = []
pointsByLoc = {}

startPoint = None

for rowNum in range(len(nums)):
	for colNum in range(len(nums[0])):
		point = Point(rowNum, colNum, nums[rowNum][colNum])
		if rowNum == 0 and colNum == 0:
			point.cost = 0
			point.pathCost = 0
			startPoint = point
		unvisited.append(point)
		pointsByLoc[f'{rowNum},{colNum}'] = point
endPointId = point.getID()

for p in unvisited:
	p.connects = p.getConnects(pointsByLoc)
	
end = findPath(startPoint, unvisited)
print(end)


#for p in unvisited:
#	print(p)