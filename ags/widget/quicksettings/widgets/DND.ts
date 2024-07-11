import { SimpleToggleButton } from "../ToggleButton"
import icons from "lib/icons"

const n = await Service.import("notifications")
const dnd = n.bind("dnd")

export const DND = () => SimpleToggleButton({
    icon: dnd.as(dnd => icons.color[dnd ? "dark" : "light"]),
    label: dnd.as(dnd => dnd ? "Night" : "Day"),
    toggle: () => n.dnd = !n.dnd,
    connection: [n, () => n.dnd],
})
