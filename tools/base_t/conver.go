package base_t

//转换接口
type Conversion interface {
	FromBytes([]byte) error
	ToBytes() ([]byte, error)
}
