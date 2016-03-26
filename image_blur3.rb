class Image
  
  def initialize(rows)
    @rows = rows
  end

  def output_image
    @rows.each do |row|
      row.each {|pixel| print pixel}
      puts ""
    end
  end


  def manhattan_distance(distance)
      #calculate the length of the largest of the 1d arrays in @rows(in case they are not equal)
      i=0
      array_1d_len = []
      while i < @rows.length
        len = @rows[i].length
        array_1d_len.push(len)
        i += 1
      end

      #create a 1-d array with the same length as largest of the 1d arrays in @rows and fill it with empty arrays
      position_map = []

      (@rows.count).times do |i|
          position_map.push([])
      end

      #Add a 2nd dimension to the array created above with the same number of rows 
      #as the array given as argument in the initialize method
      (@rows.count).times do |i|
        (array_1d_len.max).times do |j|
          position_map[i].push({type:"", association_code: "", propagation: 0})
        end
      end


      tag_O = 0   #counter for the original characters (in this case the "1´s" in the original image) 
      tag_A = 0   #counter for the altered characters

      ######### 1st major loop (used to map all the positions that should be altered)#######

      #iterate over the original 2-d array
      @rows.each.with_index do |row, index1|
        row.each.with_index do |pixel, index2|

          if pixel == 1
            tag_O += 1    #these counters allow for the creation of groups of original and associated
            tag_A += 1    #altered values by number coding (ex: all "altered" with code 2 are associated
                          #with "original" 2). This is so that when calculating the distance between the
                          #altered and original, the original used is the right one and not another 
                          #original in the array   
            
            #map the current original one
            position_map[index1][index2][:type] = "original"
            position_map[index1][index2][:association_code] = tag_O 
            position_map[index1][index2][:propagation] = 0
            
            steps = 1

            #the mapping of the ones to be altered start from those closest to the original one and extend
            #outward, one step at a time
            while steps <= distance

              #only map the alteration if there is a value to the left and if that value is not 1 already
              if index2 - steps >= 0 && @rows[index1][index2 - steps] != 1
                #map the position immediatelly before  
                position_map[index1][index2 - steps][:type] = "altered"
                position_map[index1][index2 - steps][:association_code] = tag_A 
                position_map[index1][index2 - steps][:propagation] = distance - steps
              end

              #only map the alteration if there is a value to the right and if that value is not 1 already
              if (index2 + steps) < row.count && @rows[index1][index2 + steps] != 1 
                #map the position immediatelly after
                position_map[index1][index2 + steps][:type] = "altered"
                position_map[index1][index2 + steps][:association_code] = tag_A 
                position_map[index1][index2 + steps][:propagation] = distance - steps
              end

              #only map the alteration if there is a row above it
              if index1 - steps >= 0
                #map the position directly above
                position_map[index1 - steps][index2][:type] = "altered"
                position_map[index1 - steps][index2][:association_code] = tag_A 
                position_map[index1 - steps][index2][:propagation] = distance - steps
              end

              #only map the alteration if there is a row below it and if the value directly below is not 1 already
              if (index1 + steps) < @rows.count && @rows[index1 + steps][index2] != 1 
                #mark the position directly below
                position_map[index1 + steps][index2][:type] = "altered"
                position_map[index1 + steps][index2][:association_code] = tag_A 
                position_map[index1 + steps][index2][:propagation] = distance - steps
              end
              steps += 1
            end
          end
        end
      end
      ###### end of 1st major loop ###############################

      ###### 2nd major loop (used to alter the values of the original image based on the map created above########################################

        position_map.each.with_index do |row, index1|
          row.each.with_index do |pixel, index2|

          #skip the current iteration if the value "1" is original  
          if position_map[index1][index2].has_value?("original")
            next
          end

          if pixel.has_value?("altered")
            steps_2 = 1
            distance_2 = position_map[index1][index2][:propagation] #the propagation measures how far the altered values can
                                                                    #alter other ones on behalf of the original ones 
            while steps_2 <= distance_2

              #only make the alteration if there is a value to the left and if that value is not 1 already
              if index2 - steps_2 >= 0 && @rows[index1][index2 - steps_2] != 1  
                @rows[index1][index2 - steps_2] = 1
              end

              #only make the alteration if there is a value to the right and if that value is not 1 already
              if (index2 + steps_2) < row.count && @rows[index2 + steps_2] != 1
                @rows[index1][index2 + steps_2] = 1
              end

              #only make the alteration if there is a value above and if that value is not 1 already
              if index1 - steps_2 >= 0 && @rows[index1 - steps_2][index2] != 1
                @rows[index1 - steps_2][index2] = 1
              end

              #only make the alteration if there is a value below and if that value is not 1 already
              if (index1 + steps_2) < @rows.count && @rows[index1 + steps_2][index2] != 1
                @rows[index1 + steps_2][index2] = 1
              end
              steps_2 += 1
            end
          end
        end
      end
      #puts position_map.inspect
  end

end

image = Image.new([
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
])

image.manhattan_distance(3)
image.output_image