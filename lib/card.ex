defrecord Card, suit: nil, rank: nil, points: nil do

  def describe(record) do
      "#{record.rank} of #{record.suit} (#{record.points})"
  end

end
