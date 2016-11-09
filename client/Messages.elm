module Messages exposing (..)

-- import Time exposing (Time)

import Routes


-- Messages


type Msg
    = NavigateTo (Maybe Routes.Location)
    | ClientMsg' ClientMsg
      -- | ProjectMsg' ProjectMsg
      -- | StopwatchMsg' StopwatchMsg
    | NoOp


type ClientMsg
    = CreateClient String
    | ShowClient Int
    | DeleteClient Int
    | UpdateClient Int String



-- type ProjectMsg
--     = FetchProjects
--     | CreateProject
--     | ShowProject Int
--     | DeleteProject Int
--     | UpdateProject Int
-- type StopwatchMsg
--     = FetchStopwatches
--     | CreateStopwatch
--     | ShowStopwatch Int
--     | DeleteStopwatch Int
--     | UpdateStopwatch Int Time
--     | StartStopwatch Int
--     | PauseStopwatch Int
--     | StopStopwatch Int
