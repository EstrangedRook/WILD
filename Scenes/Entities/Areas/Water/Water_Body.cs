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

    public override void _Ready()
    {
        surface_1 = GetNode<Line2D>("Water_Surface_1");
        surface_2 = GetNode<Line2D>("Water_Surface_2");
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

        for(int j = 0; j < length; j++)
        { 
            if(j > 0)
            {
                left_deltas[j] = water_spread * (water_surface[j].position.y - water_surface[j - 1]. position.y);
                water_surface[j - 1].velocity.y += left_deltas[j];
            }
            if(j < length - 1)
            {
                right_deltas[j] = water_spread * (water_surface[j].position.y - water_surface[j + 1]. position.y);
                water_surface[j + 1].velocity.y += right_deltas[j];
            }

            if(j > 0)
            {
                water_surface[j-1].position.y += left_deltas[j];
            }
            if(j < length - 1)
            {
                water_surface[j+1].position.y += right_deltas[j];
            }
        }

        polygon_body[length] = bounds[1];
        polygon_body[length+1] = new Vector2(bounds[0].x, bounds[1].y);
        Polygon = polygon_body;
    }

    public void Splash(int index, float power)
    {
        if(index >= 0 && index < length)
        {
            water_surface[index].velocity.y = power;
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
        float x = position.y + target_height;
        float acceleration = -k * x;
        acceleration -= dampening * velocity.y;

        position += velocity;
        velocity.y += acceleration;
    }

}