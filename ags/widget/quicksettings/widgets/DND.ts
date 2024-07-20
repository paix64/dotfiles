import { SimpleToggleButton } from "../ToggleButton"
import icons from "lib/icons"

const n = await Service.import("notifications")
const dnd = n.bind("dnd")

export const DND = () => SimpleToggleButton({
    icon: dnd.as(dnd => icons.color[dnd ? "light" : "light"]),
    label: dnd.as(dnd => dnd ? "Night Light" : "Night Light"),
    toggle: () => n.dnd = !n.dnd,
    connection: [n, () => n.dnd],
})
