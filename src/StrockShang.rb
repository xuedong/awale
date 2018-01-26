# -*- coding: iso-8859-1 -*-
class StrockShang
  
  def initialize
    file = File.open("../data/arbre5.txt", "r")
    @total = 0
    @prevision = eval(file.read)
    @test = true
    #p(@prevision)
  end
  
  def name
    return "StrockShang"
  end
  
  def calcpos(feuille,x,player)
    if feuille[0] == nil
      p("test")
    else
      infloop = Set.new
      joueur0 = Array.new(feuille[0][0])
      joueur1 = Array.new(feuille[0][1])
      board = [joueur0,joueur1]
      #p(feuille)
      score = Array.new(feuille[1])
      pos = [player,x]
      k = 0
      while (true)
        # (for i in 0..11
        #   $stdout << board[i/6][i%6]
        #   $stdout << " "
        # end
        # $stdout << "\n"
        # $stdout << k
        # $stdout << "\n"
        k += 1
        if infloop.include?([board,pos]) || k > 100000
          tab = []
          tab[player] = score[player]
          tab[1-player] = 48 - score[player]
          return [nil,tab]
        else
          infloop << [board,pos]
          graines = board[pos[0]][pos[1]]
          # p(board)
          grainesq = graines/12
          grainesr = graines%12
          for i in 0..5
            if i == pos[1]
              board[pos[0]][i]=grainesq
            else
              board[pos[0]][i]+=grainesq
            end
            board[1-pos[0]][i]+=grainesq
          end
          if grainesr != 1
            for j in 1..grainesr
              if pos[0]==0
                board[(j+pos[1])/6%2][(j+pos[1])%6]+=1
              else
                board[1-((j+pos[1])/6)%2][(j+pos[1])%6]+=1
              end	
            end
          end
        end		
        if pos[0]==0
          side = ((pos[1]+graines)/6)%2
          loc = (pos[1]+graines)%6
          if board[side][loc]==1
            if side == player
              tab = []
              tab[player] = score[player]+1+board[1-side][5-loc]
              #  $stdout << board[1-side][5-loc]
              #  $stdout << " "
              #  $stdout << loc
              #  $stdout << "\n"
              tab[1-player] = score[1-player]
              board[player][loc] = 0
              board[1-player][5-loc] = 0
              return [board,tab]
            else
              return [board,score]
            end
          else
            pos = [side,loc]
          end
        else
          side = 1-((pos[1]+graines)/6)%2
          loc = (pos[1]+graines)%6
          if board[side][loc]==1
            if side == player
              tab = []
              tab[player] = score[player]+1+board[1-side][5-loc]
              #  $stdout << board[1-side][5-loc]
              #  $stdout << " "
              #  $stdout << loc
              #  $stdout << "\n"
              tab[1-player] = score[1-player]
              board[player][loc] = 0
              board[1-player][5-loc] = 0
              return [board,tab]
            else
              return [board,score]
            end
          else 
            pos = [side,loc]
          end
        end
      end
    end	
  end
  
  def calcpos2(feuille,x,player)
    if feuille[0] == nil
      return feuille
    else
      infloop = Set.new
      joueur0 = Array.new(feuille[0][0])
      joueur1 = Array.new(feuille[0][1])
      board = [joueur0,joueur1]	
      score = Array.new(feuille[1])
      pos = [player,x]
      k = 0
      while (true)
        # (for i in 0..11
        #   $stdout << board[i/6][i%6]
        #   $stdout << " "
        # end
        # $stdout << "\n"
        # $stdout << k
        # $stdout << "\n"
        k += 1
        if infloop.include?([board,pos])
          tab = []
          tab[player] = score[player]
          tab[1-player] = 48 - score[player]
          return [nil,tab]
        else
          infloop << [board,pos]
          graines = board[pos[0]][pos[1]] 
          grainesq = graines/12
          grainesr = graines%12
          for i in 0..5
            if i == pos[1]
              board[pos[0]][i]=grainesq
            else
              board[pos[0]][i]+=grainesq
            end
            board[1-pos[0]][i]+=grainesq
          end
          if grainesr != 1
            for j in 1..grainesr
              if pos[0]==0
                board[(j+pos[1])/6%2][(j+pos[1])%6]+=1
              else
                board[1-((j+pos[1])/6)%2][(j+pos[1])%6]+=1
              end	
            end
          end
        end		
        if pos[0]==0
          side = ((pos[1]+graines)/6)%2
          loc = (pos[1]+graines)%6
          if board[side][loc]==1
            if side == player
              tab = []
              tab[player] = score[player]+1+board[1-side][5-loc]
              #  $stdout << board[1-side][5-loc]
              #  $stdout << " "
              #  $stdout << loc
              #  $stdout << "\n"
              tab[1-player] = score[1-player]
              board[player][loc] = 0
              board[1-player][5-loc] = 0
              return [board,tab]
            else
              return [board,score]
            end
          else
            pos = [side,loc]
          end
        else
          side = 1-((pos[1]+graines)/6)%2
          loc = (pos[1]+graines)%6
          if board[side][loc]==1
            if side == player
              tab = []
              tab[player] = score[player]+1+board[1-side][5-loc]
              #  $stdout << board[1-side][5-loc]
              #  $stdout << " "
              #  $stdout << loc
              #  $stdout << "\n"
              tab[1-player] = score[1-player]
              board[player][loc] = 0
              board[1-player][5-loc] = 0
              return [board,tab]
            else
              return [board,score]
            end
          else 
            pos = [side,loc]
          end
        end
      end
    end
  end


  def addprofondeur(arbre,player)
    #p(arbre)
    if arbre != nil && arbre[0] != nil
      if arbre[0][0] != nil && arbre[0][0][0].class == Fixnum
        copyarbre = Array.new(arbre)
        #p(arbre)
        for i in 0..5
          arbre[i] = calcpos2(copyarbre,i,player)
          arbre[i][2] = copyarbre[2]+1
          #p(arbre)
        end
      else
        for sarbre in arbre
          addprofondeur(sarbre,player)
        end
      end
    end
  end
  
  # def addprofondeur(arbre,player)
  #   if (@test)
  #     if arbre[0] != nil
  #       if arbre[0][0] != nil && arbre[0][0][0].class == Fixnum
  #         feuille = Array.new(arbre)
  #         for i in 0..5
  #           arbre[i] = calcpos(feuille,i,player)
  #           arbre[i][2] = 4
  #         end
  #       else
  #        for i in 0..5
  #           addprofondeur(arbre[i],player)
  #         end
  #       end
  #     end
  #   else
  #     if arbre[0] == nil
  #       p(arbre)
  #       if arbre[2] == nil
  #         arbre[2] = 0
  #       else
  #         arbre[2] -= 1
  #       end
  #     elsif arbre[0][0] != nil && arbre[0][0][0].class == Fixnum
  #       feuille = Array.new(arbre)
  #      for i in 0..5
  #         arbre[i] = calcpos(feuille,i,player)
  #       end
  #     else 
  #       for i in 0..5
  #         addprofondeur(arbre[i],player)
  #       end
  #     end
  #   end
  # end

  # def initarbre(n,arbre)
  #  for i in 0...n
  #    addprofondeur(arbre,(i%2))
  #  end
  #  return arbre
  # end	
  
  def choose(awale,previous,lost)
    #print((previous.to_s)+"\n")
    #p(@prevision)
    if (@test)   
      if previous != -1
        file2 = File.open("arbred5.txt","r")
        @prevision = eval(file2.read)
        @prevision = @prevision[previous]
        addprofondeur(@prevision,0)
        addprofondeur(@prevision,1)
      else 
        addprofondeur(@prevision,1)
      end
      #p(@prevision)
      @test = false      
    else
      if @prevision[0] != nil
        @prevision = @prevision[previous]
        addprofondeur(@prevision,0)
        addprofondeur(@prevision,1) #pour améliorer on peut ajouter les deux profondeurs à la fois
        #p(@prevision)
      end
    end
    if @prevision == nil || @prevision[0] == nil
      return 0
    else
      t = []
      for i in 0..5
        t[i] = evalue(@prevision[i])
      end
      k = 0
      b = false
      for i in 0..5
        if t[k] < t[i] && awale[0][i] != 0 && @prevision[i][0] != nil
          k = i
          b = true
        end
      end
      #if previous == -1
      #  p(k.to_s)
      #else	
      #  p((previous.to_s)+"/"+(k.to_s))
      #end
      if b
        @prevision = @prevision[k]
        return k
      else
        return 0
      end
    end
  end

  def checksum(awale,position)
    b = 1
    for i in 0...6
      b += awale[0][i]+awale[1][i]
    end
    b = 12 if b < 12
    position = position % 12
    s = position
    for i in 0...12
      s *= b
      s += awale[i%2][i/2]
    end
    return s
  end

  def evalue(arbre)
    #p(arbre)
    if arbre[0] == nil
      return arbre[2]*(arbre[1][0]-arbre[1][1])
    elsif arbre[0][0] != nil && arbre[0][0][0].class == Fixnum
      return arbre[1][0]-arbre[1][1]
    else
      s = 0
      for i in 0..5
        s += evalue(arbre[i])
      end
      return s
    end
  end
  
  def earn(score)
    @total += score
  end

end
