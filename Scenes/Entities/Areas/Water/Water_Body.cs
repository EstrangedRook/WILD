using Godot;
using System;

public class Water_Body : Polygon2D
{
    [Export] public int length = 10;
    [Export] public float water_spread = 0.1f;
    [Export] public float dampening = 0.05f;
    [Export] public float tension = 0.025f;
    [Export] public float segment_spread = 4;
    [Export] public float dampening_threshold = 3;
    [Export] public Vector2[] bounds = new Vector2[] {new Vector2(0, 0), new Vector2(0, 10)};
    private Water_Segment_Poly[] water_surface = new Water_Segment_Poly[1000];
    private float[] left_deltas = new float[1000];
    private float[] right_deltas = new float[1000];
    private Line2D surface_1;
    private Line2D surface_2;
    private ConvexPolygonShape2D collider;

    public override void _Ready()
    {
        surface_1 = GetNode<Line2D>("Water_Surface_1");
        surface_2 = GetNode<Line2D>("Water_Surface_2");
        collider = (ConvexPolygonShape2D)GetNode<CollisionShape2D>("Collider/CollisionShape2D").Shape;
        Vector2[] polygon_body = new Vector2[length+2];
        segment_spread = Math.Abs(bounds[1].x - bounds[0].x)/(length-1);
        for(int i = 0; i < length; i++)
        {
            water_surface[i] = new Water_Segment_Poly(new Vector2((i * segment_spread) + bounds[0].x, bounds[0].y));
            polygon_body[i] = water_surface[i].position;
            surface_1.AddPoint(water_surface[i].position);
            surface_2.AddPoint(new Vector2(water_surface[i].position.x, water_surface[i].position.y + 1));
            left_deltas[i] = 0;
            right_deltas[i] = 0;
        }
        polygon_body[length] = bounds[1];
        polygon_body[length+1] = new Vector2(bounds[0].x, bounds[1].y);
        Polygon = polygon_body;
        collider.Points = polygon_body;
    }

    public override void _Process(float delta)
    {
        Vector2[] polygon_body = new Vector2[length+2];
        for(int i = 0; i < length; i++)
        {
            water_surface[i].Update(dampening, tension, bounds[0].y);
            if(i <= 0 || i >= length - 1 || water_surface[i].position.y < bounds[0].y + dampening_threshold &&  water_surface[i].position.y > bounds[0].y - dampening_threshold)
            {
                water_surface[i].position.y = bounds[0].y;
            }
            polygon_body[i] = water_surface[i].position;
            surface_1.SetPointPosition(i, water_surface[i].position);
            surface_2.SetPointPosition(i, new Vector2(water_surface[i].position.x, water_surface[i].position.y + 1)); 
        }
        for(int i = 0; i < 8; i++)
        {
            for(int j = 0; j < length; j++)
            {
                Process_Deltas(j);
                Process_Deltas((length-1) - j);
            }
        }
        polygon_body[length] = bounds[1];
        polygon_body[length+1] = new Vector2(bounds[0].x, bounds[1].y);
        Polygon = polygon_body;
        collider.Points = polygon_body;
    }

    public void Splash(int index, float power)
    {
        if(index >= 0 && index < length)
        {
            water_surface[index].velocity.y = power;
        }
    }

    public void Process_Deltas(int index)
    {
        if(index > 0)
        {
            left_deltas[index] = water_spread * (water_surface[index].position.y - water_surface[index - 1]. position.y);
            water_surface[index - 1].velocity.y += left_deltas[index];
        }
        if(index < length - 1)
        {
            right_deltas[index] = water_spread * (water_surface[index].position.y - water_surface[index + 1]. position.y);
            water_surface[index + 1].velocity.y += right_deltas[index];
        }
        if(index > 0)
        {
            water_surface[index-1].position.y += left_deltas[index];
        }
        if(index < length - 1)
        {
            water_surface[index+1].position.y += right_deltas[index];
        }
    }
}

public class Water_Segment_Poly
{
    public Vector2 position;
    public Vector2 velocity;

    public Water_Segment_Poly(Vector2 position)
    {
        this.position = position;
        velocity = new Vector2(0, 0);
    }

    public void Update(float dampening, float tension, float target_height)
    {
        float k = tension;
        float x = position.y - target_height;
        velocity.y += (-k * x) - (velocity.y * dampening);
        position += velocity;
    }
}