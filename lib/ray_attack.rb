# Generates legal ray attacks based on the current pieces on the board
module Ray_Attack
  def gen_upper_ray(ray, occupied)
    lsb = ray & occupied
    lsb &= -lsb
    lsb | (ray & (lsb - 1))
  end

  def gen_lower_ray(ray, occupied)
    msb = ray & occupied
    msb = (msb == 0 ? 0 : (1 << msb).bit_length)
    msb | (ray & (msb ^ -msb))
  end
end