module Stream where

data ObjectStream a = EmptyStream | Object a | Stream (ObjectStream a) (ObjectStream a) deriving (Show, Read, Eq)

{-
	EXEMPLOS DE USO:
	* Criando um Stream:
		let x = EmptyStream															"Stream Vazia"
		let y = Stream (Object "object1") EmptyStream								"Stream com um objeto"
		let z = Stream (Object "object1") (Stream (Object "object2") EmptyStream)	"Stream com dois objetos"
-}

stream_endp :: ObjectStream a -> Bool
stream_endp EmptyStream = True
stream_endp (Stream _ _) = False

stream_first :: ObjectStream a -> ObjectStream a
stream_first (Stream first _) = first

stream_rest :: ObjectStream a -> ObjectStream a
stream_rest (Stream _ rest) = rest

stream_cons :: ObjectStream a -> ObjectStream a -> ObjectStream a
stream_cons objeto stm = (Stream objeto stm)

stream_append :: ObjectStream a -> ObjectStream a -> ObjectStream a
stream_append stm1 stm2 =
	if (stream_endp stm1) then stm2 
	else stream_cons (stream_first stm1) (stream_append (stream_rest stm1) stm2)

stream_concatenate :: ObjectStream a -> ObjectStream a
stream_concatenate streams
	| stream_endp streams = EmptyStream
	| stream_endp (stream_first streams) = stream_concatenate (stream_rest streams)
	| otherwise = stream_cons (stream_first (stream_first streams)) 
								(stream_concatenate (stream_cons (stream_rest (stream_first streams))
													(stream_rest streams)))