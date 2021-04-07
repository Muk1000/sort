#!/usr/bin/lua5.3

--[[ 
  Welcome to the LUA Bar! 
]]

-- Didn't this used to be the SCUMM Bar?

------------------------
-- SORTING ALGORITHMS --
------------------------

-- Setup --

-- Constants
iterations = 100
arrayLength = 100
maxValue = 100

-- Counters
-- Note that these counters slow down the runtime
bubbleSwaps = 0
bubbleComparisons = 0
insertionSwaps = 0
insertionComparisons = 0

--------------------------------------------------------------------------------

-- Functions --

--[[
  printArray

  Prints out an array on a single line with spaces between values.
]]

function printArray(arr)
  -- Check if this is an array of arrays in a hacky way
  if type(arr[1]) == "table" then
    -- Call printArray again on each array
    for i = 1, #arr, 1 do
      printArray(arr[i])
    end
  else
    -- Concatenates the values in the array into a string and prints it
    print(table.concat(arr, " "))
  end
end

--[[
  createRandomArray

  Creates an array of random numbers. Takes the length of the array and the
  maximum value.
]]

function createRandomArray(len, max)
  local arr = {}

  -- Seeding with just os.time() causes the same number to be generated for
  -- runs during the same second. This adds some randomness by creating an
  -- anonymous array, getting its location in memory with tostring(), removing
  -- the "table: " part of the address with substring, and converting the
  -- location to a number.

  math.randomseed(os.time() + tonumber(tostring({}):sub(8)))

  -- Generated random numbers and fill the array
  for i = 1, len, 1 do
    arr[i] = math.random(max)
  end

  return arr
end

--[[
  copyArray

  Copies an array into a new one. Doing arr1 = arr2 just copies the reference.
]]

function copyArray(arr)
  local copy = {}

  -- Copy each element
  for i = 1, #arr, 1 do
    -- Check if this element is an array itself
    if type(arr[i]) == "table" then
      -- Call copyArray again on this new array
      copy[i] = copyArray(arr[i])
    else
      -- Copy the element
      copy[i] = arr[i]
    end
  end

  return copy
end

--[[
  bubbleSort

  It's bubble sort! It sorts arrays. Slowly.
]]

function bubbleSort(arr)
  -- Use a local variable to track if this run has had a swap
  local swap = 1

  -- As long as there was a swap during the last loop, keep going
  while (swap == 1) do
    -- Reset the swap tracker
    swap = 0

    -- Look at each element in the array 
    for i = 1, #arr - 1, 1 do
      -- Increment the comparison counter
      bubbleComparisons = bubbleComparisons + 1

      -- If the current element is larger than the next element, swap them
      if (arr[i] > arr[i+1]) then
        temp = arr[i]
        arr[i] = arr[i+1]
        arr[i+1] = temp

        -- Update the swap tracker
        swap = 1

        -- Increment the swap counter
        bubbleSwaps = bubbleSwaps + 1
      end
    end
  end

  return arr
end

--[[
  insertionSort

  This sorts arrays slightly faster.
]]

function insertionSort(arr)
  -- Look at each element in the array, starting with the second
  for i = 2, #arr, 1 do
    -- We're always going to do at least one comparison
    insertionComparisons = insertionComparisons + 1

    -- We know any previous elements have already been sorted
    -- Move the current element backwards through the array until we find a
    -- smaller value or the beginning
    j = i
    while (j > 1 and arr[j-1] > arr[j]) do
      temp = arr[j-1]
      arr[j-1] = arr[j]
      arr[j] = temp
      j = j - 1

      -- Increment the counters
      insertionSwaps = insertionSwaps + 1
      insertionComparisons = insertionComparisons + 1
    end
  end

  return arr
end

--------------------------------------------------------------------------------

-- Main --

-- Build a 2D array of test arrays, so all sorts use the same data
data = {}
for i = 1, iterations, 1 do
  data[i] = createRandomArray(arrayLength, maxValue)
end

-- print("Original data")
-- printArray(data)

-- Run Bubble Sort
bubbleSorted = {}
bubbleData = copyArray(data)
clock = os.clock()
for i = 1, iterations, 1 do
  bubbleSorted[i] = bubbleSort(bubbleData[i])
end

print()
-- print("Bubble Sorted")
-- printArray(bubbleSorted)
print("Time to bubble sort: ", os.clock() - clock)
print("Total swaps: ", bubbleSwaps)
print("Total comparisons: ", bubbleComparisons)

-- Insertion Sort
insertionSorted = {}
insertionData = copyArray(data)
clock = os.clock()
for i = 1, iterations, 1 do
  insertionSorted[i] = insertionSort(insertionData[i])
end

print()
-- print("Insertion Sorted")
-- printArray(insertionSorted)
print("Time to insertion sort: ", os.clock() - clock)
print("Total swaps: ", insertionSwaps)
print("Total comparisons: ", insertionComparisons)
