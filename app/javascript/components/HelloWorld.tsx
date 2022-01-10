import React from "react"

type Props = {
  greeting: string
}

const HelloWorld: React.VFC<Props> = ({ greeting }) => {
  return <div>
    Greetingts: {greeting}
  </div>
}
export default HelloWorld
