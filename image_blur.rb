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


  def one_pixel_transf
      
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
      (array_1d_max_len.max).times do |i|
        holder_1d.push(0)
      end

      #use the 1-d array above to create a 2-d array with the same number of rows 
      #as the array given as argument in the initialize method
      holder_2d = []

      (@rows.count).times do |i|
        holder_2d.push(holder_1d)
      end

      #iterate over the original 2-d array
      @rows.each.with_index do |row, index1|
        row.each.with_index do |pixel, index2|

          #check if the value at the current coordinates of the @rows array was originally 1 or
          # if it is 1 because it was altered by the algorithm. Changed values correspond to a
          #"altered" value in the holder array at the same coordinates. The storing is done further down  
          if holder_2d[index1][index2] == "altered"
            next
          end

          if pixel == 1

            #only make the alteration if there is a value to the left and if that value is not 1 already
            if index2 - 1 >= 0 && row[index2 - 1] != 1  
              row[index2 - 1] = 1
              #puts "@rows[#{index1}][#{index2-1}] altered to #{row[index2 - 1]}"
            end

            #only make the alteration if there is a value to the right and if that value is not 1 already
            if index2 + 1 < row.count && row[index2 + 1] != 1
              
              #mark the position immediately after it as "altered" and store it in the holder array
              holder_2d[index1][index2 + 1] = "altered"
              
              #row[index2 + 1] = "r"
              row[index2 + 1] = 1
              #puts "@rows[#{index1}][#{index2+1}] altered to #{@rows[index1][index2+1]}"
            end

            #only make the alteration if there is a row above it
            if index1 -1 >=0
              #@rows[index1 -1][index2] = "u"
              @rows[index1 -1][index2] = 1
              #puts "@rows[#{index1-1}][#{index2}] altered to #{@rows[index1-1][index2]}"
            end

            #only make the alteration if there is a row below it and if the value directly below is not 1 already
            if index1 + 1 < @rows.count && @rows[index1 + 1][index2] != 1
              
              #mark the position directly below it as "altered" and store it in the holder array
              holder_2d[index1 + 1][index2] = "altered"
              
              #@rows[index1 + 1][index2] = "d"
              @rows[index1 + 1][index2] = 1
              #puts "@rows[#{index1+1}][#{index2}] altered to #{@rows[index1+1][index2]}"
            end
          end
        end
      end
  end 

end
=begin
image = Image.new([
  [0, 0, 0, 0],
  [0, 1, 0, 0],
  [0, 0, 0, 1],
  [0, 0, 0, 0]
])
=end
image = Image.new([
  [0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0],
  [0, 0, 1, 0, 0, 1],
  [0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0],
  [0, 1, 0, 0, 0, 1],
  [0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0],
  [1, 0, 0, 1, 0, 1],
  [0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0],
  [1, 0, 0, 1, 0, 0],
  [0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0]
])

image.one_pixel_transf
image.output_image