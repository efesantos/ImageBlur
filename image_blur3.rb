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
      array_1d_max_len = []
      while i < @rows.length
        len = @rows[i].length
        array_1d_max_len.push(len)
        i += 1
      end


      #create a 1-d array with the same length as largest of the 1d arrays in @rows and fill it with zeros
      #given as argument in the initialize method 
      holder_1d = []
      9.times do |i|
        holder_1d.push(0)
      end

      #use the 1-d array above to create a 2-d array with the same number of rows 
      #as the array given as argument in the initialize method
      @holder_2d = []

      (@rows.count).times do |i|
        @holder_2d.push([["- - - -"], ["- - - -"], ["- - - -"], ["- - - -"], ["- - - -"], ["- - - -"], ["- - - -"], ["- - - -"], ["- - - -"]])
      end

      tag_O = 0
      tag_A = 0

      #iterate over the original 2-d array
      @rows.each.with_index do |row, index1|
        row.each.with_index do |pixel, index2|
          #check if the value at the current coordinates of the @rows array was originally 1 or
          # if it is 1 because it was altered by the algorithm. Changed values correspond to a
          #"altered" value in the holder array at the same coordinates. The storing is done further down.If the current value has been
          #altered, the current iteration is skipped.   
          if @holder_2d[index1][index2].include? "a"
            next
          end

          if pixel == 1
            tag_O += 1
            tag_A += 1
            #holder_2d[index1][index2] = "O"+tag_O.to_s
            @holder_2d[index1][index2].push("O", tag_O, "").shift
            steps = 1
            while steps <= distance

              #only make the alteration if there is a value to the left and if that value is not 1 already
              if index2 - steps >= 0 && row[index2 - steps] != 1  
                #holder_2d[index1][index2 - steps] = "a"+tag_A.to_s
                @holder_2d[index1][index2 - steps].push("a", tag_A, distance - steps).shift
                row[index2 - steps] = 1
                #puts "@rows[#{index1}][#{index2-steps}] altered to #{row[index2 - steps]}"
                #puts ""
              end

              #only make the alteration if there is a value to the right and if that value is not 1 already
              if (index2 + steps) < row.count && row[index2 + steps] != 1
                
                #mark the position immediately after it as "altered" and store it in the holder array
                #holder_2d[index1][index2 + steps] = "a"+tag_A.to_s
                @holder_2d[index1][index2 + steps].push("a", tag_A, distance - steps).shift
                #puts "step = #{steps}"
                #puts "index1 = #{index1}, index2 = #{index2}"
                #puts holder_2d.inspect
                #row[index2 + 1] = "r"
                row[index2 + steps] = 1
                #puts "@rows[#{index1}][#{index2+steps}] altered to #{@rows[index1][index2+steps]}"
                #puts ""
              end

              #only make the alteration if there is a row above it
              if index1 - steps >= 0
                #@rows[index1 -1][index2] = "u"
                #holder_2d[index1 - steps][index2] = "a"+tag_A.to_s
                @holder_2d[index1 - steps][index2].push("a", tag_A, distance - steps).shift
                @rows[index1 - steps][index2] = 1
                #puts "@rows[#{index1-steps}][#{index2}] altered to #{@rows[index1-steps][index2]}"
                #puts ""
              end

              #only make the alteration if there is a row below it and if the value directly below is not 1 already
              if (index1 + steps) < @rows.count && @rows[index1 + steps][index2] != 1
                
                #mark the position directly below it as "altered" and store it in the holder array
                #holder_2d[index1 + steps][index2] = "a"+tag_A.to_s
                @holder_2d[index1 + steps][index2].push("a", tag_A, distance - steps).shift
                #puts holder_2d.inspect
                #@rows[index1 + 1][index2] = "d"
                @rows[index1 + steps][index2] = 1
                #puts "@rows[#{index1+steps}][#{index2}] altered to #{@rows[index1+steps][index2]}"
                #puts ""
              end
              steps += 1
            end
          end
        end
      end
        @holder_2d.each do |row|
          row.each {|pixel| print pixel}
          puts ""
        end
        puts ""


        tag_O = 0
        tag_A = 0
        #Similar to the loop above but with the holder array instead
        @holder_2d.each.with_index do |row, index1|
        row.each.with_index do |pixel, index2|

          if @holder_2d[index1][index2].include? "O"
            next
          end

          if pixel.include? "a"
            steps_2 = 1
            distance_2 = @holder_2d[index1][index2].last
            while steps_2 <= distance_2

              if index2 - steps_2 >= 0 && @rows[index1][index2 - steps_2] != 1  
                @rows[index1][index2 - steps_2] = 1
              end

              if (index2 + steps_2) < row.count && @rows[index2 + steps_2] != 1
                @rows[index1][index2 + steps_2] = 1
              end

              if index1 - steps_2 >= 0
                @rows[index1 - steps_2][index2] = 1
              end

              if (index1 + steps_2) < @rows.count && @rows[index1 + steps_2][index2] != 1
                @rows[index1 + steps_2][index2] = 1
              end
              steps_2 += 1
            end
          end
        end
      end

  end

end

image = Image.new([
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 1, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 1, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0]
])

image.manhattan_distance(4)
image.output_image