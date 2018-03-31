class Point < ApplicationRecord
  
  validates :name, length: {maximum: 255}
  validates :lat, numericality: true
  validates :lng, numericality: true
  
  def self.to_json_for_gmap(arg) # 各ポイント情報が入ったjsonを作成
    ary = []
    
    if arg.class == ActiveRecord_Relation
      arg.each do |point|
        ary.push({description:point.name, pos:{lat:point.lat, lng:point.lng}})
      end
    elsif arg.class == Point
      ary.push({description: nil, pos:{lat: arg.lat, lng: arg.lng}})
    end
      
    ary.to_json
  end

end
