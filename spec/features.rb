bn = makebelieve::Network do
  
  name   "Earthquakes and Burglaries"
  author "Kristopher J. Kosmatka"
  date   DateTime.now
  
  variables do
    boolean  :alarm
    boolean  :neighbor_call
    boolean  :burglary
    discrete :earthquake, [:none, :medium, :large]
  end
  
  probabilities do
    alarm :given => [:burglary, :earthquake] do
      [[0.5, 0.5], [0.5, 0.5], [0.5, 0.5],
       [0.5, 0.5], [0.5, 0.5], [0.5, 0.5]]
    end
    neighbor_call :given => :alarm do
      [[0.9, 0.1],
       [0.8, 0.2]]
    end
    burglary   [0.1, 0.9]
    earthquake [0.01, 0.09, 0.9]
  end
  
end

bn.ask :burglary, :by => :enumeration do
  given :earthquake    => :medium, 
        :neighbor_call => false,
        :alarm         => false
end

bn.ask :burglary, :by => :elimination do
  given :neighbor_call => false,
        :alarm         => false
end

bn.ask :burglary, :by => :gibbs_sampling do
  given :neighbor_call => false
end

