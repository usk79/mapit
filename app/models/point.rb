class Point < ApplicationRecord
  
  validates :name, length: {maximum: 255}
  validates :lat, numericality: true
  validates :lng, numericality: true
  
  def self.to_json_for_gmap(arg) # 各ポイント情報が入ったjsonを作成
    
    if arg.class == ActiveRecord_Relation
      data = []
      arg.each do |point|
        data.push({id: point.id, description: point.name, pos:{lat: point.lat, lng: point.lng}})
      end
    elsif arg.class == Point
      data = {id: arg.id, description: nil, pos:{lat: arg.lat, lng: arg.lng}}
    end
      
    data.to_json
  end
  
  def self.get_gravity_center(arg)  # pointsの重心を算出
    lat_sum = 0
    lng_sum = 0
    
    arg.each do |point|
      lat_sum += point.lat
      lng_sum += point.lng
    end
    
    {lat: lat_sum / arg.size, lng: lng_sum / arg.size}.to_json
  end
  
end
